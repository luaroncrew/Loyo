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

public var TEST_SHOP_TOKEN_ADDRESS = EthereumAddress("0x0D138a23541905e963a32eBD227C96ec741408a0")
public var TEST_REGISTRY_URL: URL = URL(string: "https://ens-gateway.gregskril.workers.dev/")!


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

struct PrepareTxResponse: Codable {
    let relayWorkerAddress: String
    // Add other fields here if needed
}


let SHOP_AGGREGATOR_ADDRESS = "0x1613beB3B2C4f22Ee086B2b38C1476A3cE7f78E8"
let PAYMASTER_ADDRESS = "0x5FC8d32690cc91D4c39d9d3abcBD16989F875707"
let FORWARDER_ADDRESS = "0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9"
let RELAY_SERVER = "http://127.0.0.1:58115"
let NODE_RPC = "https://goerli.infura.io/v3/3aef5670598a414992a39bdaeb5880e0"

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
    
    func executePayment(shopContractAddress: EthereumAddress, amount: Int) async throws {
        let _amount = BigUInt(amount * 1000000000000000000)
        guard let account = self.account else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Ethereum account is not initialized"])
        }
        guard let clientUrl = URL(string: NODE_RPC) else { return }
        let client = EthereumHttpClient(url: clientUrl)

        do {
            let shopContract = ShopContract(contract: shopContractAddress.asString(), client: client)
            let txHash = try await shopContract.transfer(to: shopContractAddress, amount: _amount, account: account)
            print("txhash: \(txHash)")
        } catch (let error) {
            print("error happened: \(error)")
        }
    }
    
    
    func executeRelayedPayment(shopContractAddress: EthereumAddress, amount: BigUInt) async throws {
        guard let account = self.account else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Ethereum account is not initialized"])
        }
        
        guard let clientUrl = URL(string: NODE_RPC) else { return }
        let client = EthereumHttpClient(url: clientUrl)
        
        do {
            let shopContract = ShopContract(contract: shopContractAddress.asString(), client: client)
            
            let gasPrice = try await client.eth_gasPrice()
            let to = shopContractAddress
            let from = account.address
            let tryCall = ShopFunctions.transfer(contract: shopContractAddress, from: from, gasPrice: gasPrice, to: to, amount: amount)
            let subdata = try tryCall.transaction()
            let gas = try await client.eth_estimateGas(subdata)
            let function = ShopFunctions.transfer(contract: shopContractAddress, from: from, gasLimit: gas, to: to, amount: amount)
            let data = try function.transaction()
            
            
            // Inject pending nonce
            let nonce = try await client.eth_getTransactionCount(address: account.address, block: .Pending)
            
            var transaction = data
            transaction.nonce = nonce
            
            if transaction.chainId == nil, let network = client.network {
                transaction.chainId = network.intValue
            }
            
            // TODO: must be refactored. Forwarder accepts EIP-712 signed data structures
            guard let _ = transaction.chainId, let signedTx = (try? account.sign(transaction: transaction)), let transactionHex = signedTx.raw?.web3.hexString else {
                throw EthereumClientError.encodeIssue
            }
            
            // preparing transaction
            let txFrom = signedTx.transaction.from!.asString()
            let txTo = signedTx.transaction.to.asString()
            guard let data = signedTx.transaction.data else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data available in this transaction."])
            }
            let hexString = data.map { String(format: "%02hhx", $0) }.joined()
            let txData = "0x" + hexString
            let txValue = signedTx.transaction.value
            let txNonce = signedTx.transaction.nonce
            let txGas = signedTx.transaction.gas
            let validUntilTime = "1694596911"
            
            // building signature
            let rHex = signedTx.signature.r.map { String(format: "%02x", $0) }.joined()
            let sHex = signedTx.signature.s.map { String(format: "%02x", $0) }.joined()
            let vHex = String(format: "%02x", signedTx.signature.v)
            let txSignature = "0x" + rHex + sHex + vHex

            
    
            // Create the URL of your API endpoint
            let prepareTxUrl = URL(string: "\(RELAY_SERVER)/getaddr?paymaster=\(PAYMASTER_ADDRESS)")!
            var prepareTxRequest = URLRequest(url: prepareTxUrl)
            prepareTxRequest.httpMethod = "GET"
            let prepareTxTask = URLSession.shared.dataTask(with: prepareTxRequest) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                } else if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(PrepareTxResponse.self, from: data)
                        let relayWorkerAddress = response.relayWorkerAddress
                        let preparedTx = """
            {
                        "relayRequest": {
                            "request": {
                                "to": "\(txTo ?? "")",
                                "data": "\(txData ?? "")",
                                "from": "\(txFrom ?? "")",
                                "value": "\(txValue ?? 0)",
                                "nonce": "\(txNonce ?? 0)",
                                "gas": "\(gas)",
                                "validUntilTime": "\(validUntilTime)"
                            },
                            "relayData": {
                                "relayWorker": "\(relayWorkerAddress)",
                                "transactionCalldataGasUsed": "0x6f1812",
                                "paymasterData": "0x",
                                "maxFeePerGas": "0x3b9a56ca0",
                                "maxPriorityFeePerGas": "0x3b9a55ca0",
                                "paymaster": "\(PAYMASTER_ADDRESS)",
                                "clientId": "1",
                                "forwarder": "\(FORWARDER_ADDRESS)"
                            }
                        },
                        "metadata": {
                            "domainSeparatorName": "GSN Relayed Transaction",
                            "maxAcceptanceBudget": "285252",
                            "relayHubAddress": "0xDc64a140Aa3E981100a9becA4E685f962f0cF6C9",
                            "relayRequestId": "0x000000006b3615d9e8db04fea622637501d4fa0d9b03b57db33f90dc7bde6578",
                            "signature": "\(txSignature)",
                            "approvalData": "0x",
                            "relayMaxNonce": 9,
                            "relayLastKnownNonce": \(txNonce ?? 0)
                        }
                    }
            """
       
                        let url = URL(string: "\(RELAY_SERVER)/relay")!
                        var request = URLRequest(url: url)
                        request.httpMethod = "POST"
                        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                        request.httpBody = preparedTx.data(using: .utf8)

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
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            }

            prepareTxTask.resume()
        } catch (let error) {
            print("error happened: \(error)")
        }
    }
    
    func updateShopBalance(shopContractAddress: EthereumAddress) async throws {
        guard let account = self.account else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Ethereum account is not initialized"])
        }
        
        guard let clientUrl = URL(string: NODE_RPC) else { return }
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
        
        guard let clientUrl = URL(string: NODE_RPC) else { return }
        let client = EthereumHttpClient(url: clientUrl)

        do {
            let aggregatorContract = ShopAggregatorContract(contract: SHOP_AGGREGATOR_ADDRESS, client: client)

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
    
    func sendToFriend(friendName: String, amount: Int) async throws {
        let friendAddress = try await self.resolveFriendName(ENSName: friendName)
        let _amount = BigUInt(amount * 1000000000000000000)
        
        guard let account = self.account else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Ethereum account is not initialized"])
        }
        guard let clientUrl = URL(string: NODE_RPC) else { return }
        let client = EthereumHttpClient(url: clientUrl)
        
        do {
            let shopContract = ShopContract(contract: TEST_SHOP_TOKEN_ADDRESS.asString(), client: client)
            let txHash = try await shopContract.transfer(to: friendAddress, amount: _amount, account: account)
            
            print("txhash: \(txHash)")
        } catch (let error) {
            print("error happened: \(error)")
        }
    }
    
    
    func resolveFriendName(ENSName: String) async throws -> EthereumAddress{
        guard let account = self.account else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Ethereum account is not initialized"])
        }
        guard let clientUrl = URL(string: NODE_RPC) else {
            return "errorResolvingClientUrl"
        }
        let client = EthereumHttpClient(url: clientUrl)
        let ens = EthereumNameService(client: client)
        let address = try await ens.resolve(ens: ENSName, mode: ResolutionMode.allowOffchainLookup)
        return address
    }
    
    func getShopBalance(shopContractAddress: EthereumAddress) async throws -> String {
        guard let account = self.account else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Ethereum account is not initialized"])
        }
        guard let clientUrl = URL(string: NODE_RPC) else {
            return "errorResolvingClientUrl"
        }
        let client = EthereumHttpClient(url: clientUrl)

        do {
            let shopContract = ShopContract(contract: shopContractAddress.asString(), client: client)
            let userBalance = try await shopContract.balanceOf(account: account.address)
            return convertToString(amount: userBalance, decimals: 18)
        } catch (let error) {
            print("error happened: \(error)")
        }
        return "errorGettingBalance"
    }
    
    
    
    func registerName(ENSName: String) async throws {
        var request = URLRequest(url: TEST_REGISTRY_URL)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "id": 13,
            "name": "Jack & Jill"
        ]
        request.httpBody = parameters.percentEncoded()
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                error == nil
            else {                                                               // check for fundamental networking error
                print("error", error ?? URLError(.badServerResponse))
                return
            }
            
            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
        }

        task.resume()
    }
}

extension Dictionary {
    func percentEncoded() -> Data? {
        map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed: CharacterSet = .urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
