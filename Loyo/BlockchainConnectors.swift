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

public struct Transfer: ABIFunction {
    public static let name = "transfer"
    public let gasPrice: BigUInt? = nil
    public let gasLimit: BigUInt? = nil
    public var contract: EthereumAddress
    public let from: EthereumAddress?

    public let to: EthereumAddress
    public let value: BigUInt

    public init(contract: EthereumAddress,
                from: EthereumAddress? = nil,
                to: EthereumAddress,
                value: BigUInt) {
        self.contract = contract
        self.from = from
        self.to = to
        self.value = value
    }

    public func encode(to encoder: ABIFunctionEncoder) throws {
        try encoder.encode(to)
        try encoder.encode(value)
    }
}

protocol BlockchainConnectorProtocol {
    var account: EthereumAccount? { get }
    func initializeAccount() throws
    func executePayment() throws
}

class BlockchainConnector: ObservableObject, BlockchainConnectorProtocol {
    
    static let shared = BlockchainConnector()
    public var account: EthereumAccount?
    @Published var isAccountInitialized = false
    
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
    
    
    func executePayment() throws {
        guard let account = self.account else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Ethereum account is not initialized"])
        }
        
        guard let clientUrl = URL(string: "https://an-infura-or-similar-url.com/123") else { return }
        let client = EthereumHttpClient(url: clientUrl)

        
        let function = Transfer(contract: "0x", from: "0x", to: "0xto", value: 100)
        let transaction = try function.transaction()

        client.eth_sendRawTransaction(transaction, withAccount: account) { result in
            switch result {
            case .success(let txHash):
                print("TX Hash: \(txHash)")
            case .failure(let error):
                print("Transaction failed with error: \(error)")
            }
        }
    }
}
