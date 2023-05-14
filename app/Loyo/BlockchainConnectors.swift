//
//  BlockchainConnectors.swift
//  Loyo
//
//  Created by Kirill on 5/8/23.
//

import Foundation
import Security
import web3
import BigInt

public struct ShopItem: Identifiable {
    public let id = UUID()
    public let website: String
    public let address: String
    public let phoneNumber: String
    public let symbol: String
    public let name: String
    public var balance: BigUInt
    public let shopContractAddress: EthereumAddress
}

class BlockchainConnector: ObservableObject {
    
    static let shared = BlockchainConnector()
    public var account: EthereumAccount?
    @Published var isAccountInitialized = false
    @Published var shops: [ShopItem] = []

    private init() { }
    
    private let privateKeyTag = "com.yourappname.privateKey".data(using: .utf8)!
    
    func createAndSavePrivateKey() throws {
        // This is just an example. EthereumKeyLocalStorage should not be used in production code
        let keyStorage = EthereumKeyLocalStorage()
        if let newAccount = try? EthereumAccount.create(replacing: keyStorage, keystorePassword: "MY_PASSWORD") {
            print(newAccount.address)
            self.account = newAccount
        } else {
            // Handle the error case when the account creation fails
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create Ethereum account"])
        }
    }
    
    func initializeAccount() {
        // This is just an example. EthereumKeyLocalStorage should not be used in production code
        let keyStorage = EthereumKeyLocalStorage()

        do {
            // Try to load the existing key
            self.account = try EthereumAccount(keyStorage: keyStorage, keystorePassword: "MY_PASSWORD")
            isAccountInitialized = true

        } catch EthereumAccountError.loadAccountError {
            // If loading fails, generate a new key
            do {
                self.account = try EthereumAccount.create(replacing: keyStorage, keystorePassword: "MY_PASSWORD")
            } catch {
                print("Failed to create Ethereum account: \(error)")
            }
            isAccountInitialized = true
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func executePayment(shopContractAddress: EthereumAddress, amount: BigUInt) async throws {
        guard let account = self.account else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Ethereum account is not initialized"])
        }
        
        guard let clientUrl = URL(string: "http://localhost:8545") else { return }
        let client = EthereumHttpClient(url: clientUrl)

        do {
            let shopContract = ShopContract(contract: shopContractAddress.asString(), client: client)
            let txHash = try await shopContract.transfer(to: shopContractAddress, amount: amount, account: account)
            
            print("txhash: \(txHash)")
        } catch (let error) {
            print("error happened: \(error)")
        }
    }
    
    
    func executeRelayedPayment(shopContractAddress: EthereumAddress, amount: BigUInt) async throws {
        guard let account = self.account else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Ethereum account is not initialized"])
        }
        
        guard let clientUrl = URL(string: "http://localhost:8545") else { return }
        let client = EthereumHttpClient(url: clientUrl)

        do {
            let shopContract = ShopContract(contract: shopContractAddress.asString(), client: client)
            
            let gasPrice = try await client.eth_gasPrice()
            let to = shopContractAddress
            let from = account.address
            
            let tryCall = ShopFunctions.transfer(contract: shopContractAddress, from: from, gasPrice: gasPrice, to: to, amount: amount)
            let subdata = try tryCall.transaction()
            let gas = try await client.eth_estimateGas(subdata)
            let function = ShopFunctions.transfer(contract: shopContractAddress, from: from, gasPrice: gasPrice,gasLimit: gas, to: to, amount: amount)
            let data = try function.transaction()
            
            
            // Inject pending nonce
            let nonce = try await client.eth_getTransactionCount(address: account.address, block: .Pending)

            var transaction = data
            transaction.nonce = nonce

            if transaction.chainId == nil, let network = client.network {
                transaction.chainId = network.intValue
            }

            guard let _ = transaction.chainId, let signedTx = (try? account.sign(transaction: transaction)), let transactionHex = signedTx.raw?.web3.hexString else {
                throw EthereumClientError.encodeIssue
            }
    
            // Create the URL of your API endpoint
            let url = URL(string: "http://localhost:3000/transactions")!

            // Create the request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            // Create the request body
            let requestBody: [String: Any] = ["signedTransaction": transactionHex]
            let requestBodyData = try! JSONSerialization.data(withJSONObject: requestBody)

            request.httpBody = requestBodyData

            // Send the request
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                } else if let data = data {
                    let str = String(data: data, encoding: .utf8)
                    print("Received data:\n\(str ?? "")")
                }
            }

            task.resume()
        } catch (let error) {
            print("error happened: \(error)")
        }
    }
    
    func updateShopBalance(shopContractAddress: EthereumAddress) async throws {
        guard let account = self.account else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Ethereum account is not initialized"])
        }
        
        guard let clientUrl = URL(string: "http://localhost:8545") else { return }
        let client = EthereumHttpClient(url: clientUrl)

        do {
            let shopContract = ShopContract(contract: shopContractAddress.asString(), client: client)
            let userBalance = try await shopContract.balanceOf(account: account.address)
            
            // iterate over all shops to update the balance
            for (index, shop) in self.shops.enumerated() {
                if shop.shopContractAddress == shopContractAddress {
                    self.shops[index].balance = userBalance
                }
            }
        } catch (let error) {
            print("error happened: \(error)")
        }
    }
    
    func fetchShops() async throws {
    
        guard let account = self.account else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Ethereum account is not initialized"])
        }
        
        guard let clientUrl = URL(string: "http://localhost:8545") else { return }
        let client = EthereumHttpClient(url: clientUrl)

        do {
            let aggregatorContract = ShopAggregatorContract(contract: "0x5fbdb2315678afecb367f032d93f642f64180aa3", client: client)

            let shopAddresses = try await aggregatorContract.getAllShops()

            var fetchedShops = [ShopItem]()
            for shopAddress in shopAddresses {
                let shopContract = ShopContract(contract: shopAddress.asString(), client: client)

                let shopWebsite = try await shopContract.shopWebsite()
                let shopAddress = try await shopContract.shopAddress()
                let shopPhoneNumber = try await shopContract.shopPhoneNumber()
                let shopSymbol = try await shopContract.symbol()
                let shopName = try await shopContract.name()
                let userBalance = try await shopContract.balanceOf(account: account.address)

                let shop = ShopItem(
                    website: shopWebsite,
                    address: shopAddress,
                    phoneNumber: shopPhoneNumber,
                    symbol: shopSymbol,
                    name: shopName,
                    balance: userBalance,
                    shopContractAddress: shopContract.contract
                )
                fetchedShops.append(shop)
            }
            
            self.shops = fetchedShops

            print("shops \(shops)")
        } catch (let error) {
            print("error happened: \(error)")
        }
    }

}
