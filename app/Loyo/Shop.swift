
//
//  swiftAbi
//  Don't change the files! this file is generated!
//  https://github.com/imanrep/
//

import BigInt
import Foundation
import web3

public protocol ShopProtocol {
  init(client: EthereumClientProtocol)

  func allowance(contractAddress: EthereumAddress , owner: EthereumAddress, spender: EthereumAddress ) async throws -> BigUInt
  func approve(contractAddress: EthereumAddress , spender: EthereumAddress, amount: BigUInt ,from: EthereumAddress, gasPrice: BigUInt) async throws -> EthereumTransaction
  func balanceOf(contractAddress: EthereumAddress , account: EthereumAddress ) async throws -> BigUInt
  func decimals(contractAddress: EthereumAddress  ) async throws -> BigUInt
  func decreaseAllowance(contractAddress: EthereumAddress , spender: EthereumAddress, subtractedValue: BigUInt ,from: EthereumAddress, gasPrice: BigUInt) async throws -> EthereumTransaction
  func increaseAllowance(contractAddress: EthereumAddress , spender: EthereumAddress, addedValue: BigUInt ,from: EthereumAddress, gasPrice: BigUInt) async throws -> EthereumTransaction
  func name(contractAddress: EthereumAddress  ) async throws -> String
  func owner(contractAddress: EthereumAddress  ) async throws -> EthereumAddress
  func shopAddress(contractAddress: EthereumAddress  ) async throws -> String
  func shopPhoneNumber(contractAddress: EthereumAddress  ) async throws -> String
  func shopWebsite(contractAddress: EthereumAddress  ) async throws -> String
  func symbol(contractAddress: EthereumAddress  ) async throws -> String
  func totalSupply(contractAddress: EthereumAddress  ) async throws -> BigUInt
  func transfer(contractAddress: EthereumAddress , to: EthereumAddress, amount: BigUInt ,from: EthereumAddress, gasPrice: BigUInt) async throws -> EthereumTransaction
}

open class Shop: ShopProtocol {
  let client: EthereumClientProtocol

  required public init(client: EthereumClientProtocol) {
      self.client = client
  }

  public func allowance(contractAddress: EthereumAddress , owner: EthereumAddress, spender: EthereumAddress) async throws -> BigUInt {
    let function = ShopFunctions.allowance(contract: contractAddress , owner: owner, spender: spender)
    let data = try await function.call(withClient: client, responseType: ShopResponses.allowanceResponse.self)
    return data.value
}
  public func approve(contractAddress: EthereumAddress , spender: EthereumAddress, amount: BigUInt, from: EthereumAddress, gasPrice: BigUInt) async throws -> EthereumTransaction {
    let tryCall = ShopFunctions.approve(contract: contractAddress, from: from, gasPrice: gasPrice, spender: spender, amount: amount)
    let subdata = try tryCall.transaction()
    let gas = try await client.eth_estimateGas(subdata)
    let function = ShopFunctions.approve(contract: contractAddress, from: from, gasPrice: gasPrice,gasLimit: gas, spender: spender, amount: amount)
    let data = try function.transaction()
    return data
}
  public func balanceOf(contractAddress: EthereumAddress , account: EthereumAddress) async throws -> BigUInt {
    let function = ShopFunctions.balanceOf(contract: contractAddress , account: account)
    let data = try await function.call(withClient: client, responseType: ShopResponses.balanceOfResponse.self)
    return data.value
}
  public func decimals(contractAddress: EthereumAddress ) async throws -> BigUInt {
    let function = ShopFunctions.decimals(contract: contractAddress )
    let data = try await function.call(withClient: client, responseType: ShopResponses.decimalsResponse.self)
    return data.value
}
  public func decreaseAllowance(contractAddress: EthereumAddress , spender: EthereumAddress, subtractedValue: BigUInt, from: EthereumAddress, gasPrice: BigUInt) async throws -> EthereumTransaction {
    let tryCall = ShopFunctions.decreaseAllowance(contract: contractAddress, from: from, gasPrice: gasPrice, spender: spender, subtractedValue: subtractedValue)
    let subdata = try tryCall.transaction()
    let gas = try await client.eth_estimateGas(subdata)
    let function = ShopFunctions.decreaseAllowance(contract: contractAddress, from: from, gasPrice: gasPrice,gasLimit: gas, spender: spender, subtractedValue: subtractedValue)
    let data = try function.transaction()
    return data
}
  public func increaseAllowance(contractAddress: EthereumAddress , spender: EthereumAddress, addedValue: BigUInt, from: EthereumAddress, gasPrice: BigUInt) async throws -> EthereumTransaction {
    let tryCall = ShopFunctions.increaseAllowance(contract: contractAddress, from: from, gasPrice: gasPrice, spender: spender, addedValue: addedValue)
    let subdata = try tryCall.transaction()
    let gas = try await client.eth_estimateGas(subdata)
    let function = ShopFunctions.increaseAllowance(contract: contractAddress, from: from, gasPrice: gasPrice,gasLimit: gas, spender: spender, addedValue: addedValue)
    let data = try function.transaction()
    return data
}
  public func name(contractAddress: EthereumAddress ) async throws -> String {
    let function = ShopFunctions.name(contract: contractAddress )
    let data = try await function.call(withClient: client, responseType: ShopResponses.nameResponse.self)
    return data.value
}
  public func owner(contractAddress: EthereumAddress ) async throws -> EthereumAddress {
    let function = ShopFunctions.owner(contract: contractAddress )
    let data = try await function.call(withClient: client, responseType: ShopResponses.ownerResponse.self)
    return data.value
}
  public func shopAddress(contractAddress: EthereumAddress ) async throws -> String {
    let function = ShopFunctions.shopAddress(contract: contractAddress )
    let data = try await function.call(withClient: client, responseType: ShopResponses.shopAddressResponse.self)
    return data.value
}
  public func shopPhoneNumber(contractAddress: EthereumAddress ) async throws -> String {
    let function = ShopFunctions.shopPhoneNumber(contract: contractAddress )
    let data = try await function.call(withClient: client, responseType: ShopResponses.shopPhoneNumberResponse.self)
    return data.value
}
  public func shopWebsite(contractAddress: EthereumAddress ) async throws -> String {
    let function = ShopFunctions.shopWebsite(contract: contractAddress )
    let data = try await function.call(withClient: client, responseType: ShopResponses.shopWebsiteResponse.self)
    return data.value
}
  public func symbol(contractAddress: EthereumAddress ) async throws -> String {
    let function = ShopFunctions.symbol(contract: contractAddress )
    let data = try await function.call(withClient: client, responseType: ShopResponses.symbolResponse.self)
    return data.value
}
  public func totalSupply(contractAddress: EthereumAddress ) async throws -> BigUInt {
    let function = ShopFunctions.totalSupply(contract: contractAddress )
    let data = try await function.call(withClient: client, responseType: ShopResponses.totalSupplyResponse.self)
    return data.value
}
  public func transfer(contractAddress: EthereumAddress , to: EthereumAddress, amount: BigUInt, from: EthereumAddress, gasPrice: BigUInt) async throws -> EthereumTransaction {
    let tryCall = ShopFunctions.transfer(contract: contractAddress, from: from, gasPrice: gasPrice, to: to, amount: amount)
    let subdata = try tryCall.transaction()
    let gas = try await client.eth_estimateGas(subdata)
    let function = ShopFunctions.transfer(contract: contractAddress, from: from, gasPrice: gasPrice,gasLimit: gas, to: to, amount: amount)
    let data = try function.transaction()
    return data
}

}
open class ShopContract {
  var ShopCall: Shop?
  var client: EthereumClientProtocol
  var contract: web3.EthereumAddress
  
  init(contract: String, client: EthereumClientProtocol) {
      self.contract = EthereumAddress(contract)
      self.client = client
      self.ShopCall = Shop(client: client)
      }
  public func allowance(owner: EthereumAddress, spender: EthereumAddress) async throws -> BigUInt{
      return try await (ShopCall?.allowance(contractAddress: contract, owner: owner, spender: spender))!
   }
   
  
    public func approve(spender: EthereumAddress,amount: BigUInt, account: EthereumAccount) async throws -> String{
      let gasPrice = try await client.eth_gasPrice()
      let transaction = try await (ShopCall?.approve(contractAddress:contract,spender: spender,amount: amount, from: account.address, gasPrice: gasPrice))!
      let txHash = try await client.eth_sendRawTransaction(transaction, withAccount: account)
      return txHash
   }
   
  public func balanceOf(account: EthereumAddress) async throws -> BigUInt{
      return try await (ShopCall?.balanceOf(contractAddress: contract, account: account))!
   }
   
  public func decimals() async throws -> BigUInt{
      return try await (ShopCall?.decimals(contractAddress: contract))!
   }
   
  
    public func decreaseAllowance(spender: EthereumAddress,subtractedValue: BigUInt, account: EthereumAccount) async throws -> String{
      let gasPrice = try await client.eth_gasPrice()
      let transaction = try await (ShopCall?.decreaseAllowance(contractAddress:contract,spender: spender,subtractedValue: subtractedValue, from: account.address, gasPrice: gasPrice))!
      let txHash = try await client.eth_sendRawTransaction(transaction, withAccount: account)
      return txHash
   }
   
  
    public func increaseAllowance(spender: EthereumAddress,addedValue: BigUInt, account: EthereumAccount) async throws -> String{
      let gasPrice = try await client.eth_gasPrice()
      let transaction = try await (ShopCall?.increaseAllowance(contractAddress:contract,spender: spender,addedValue: addedValue, from: account.address, gasPrice: gasPrice))!
      let txHash = try await client.eth_sendRawTransaction(transaction, withAccount: account)
      return txHash
   }
   
  public func name() async throws -> String{
      return try await (ShopCall?.name(contractAddress: contract))!
   }
   
  public func owner() async throws -> EthereumAddress{
      return try await (ShopCall?.owner(contractAddress: contract))!
   }
   
  public func shopAddress() async throws -> String{
      return try await (ShopCall?.shopAddress(contractAddress: contract))!
   }
   
  public func shopPhoneNumber() async throws -> String{
      return try await (ShopCall?.shopPhoneNumber(contractAddress: contract))!
   }
   
  public func shopWebsite() async throws -> String{
      return try await (ShopCall?.shopWebsite(contractAddress: contract))!
   }
   
  public func symbol() async throws -> String{
      return try await (ShopCall?.symbol(contractAddress: contract))!
   }
   
  public func totalSupply() async throws -> BigUInt{
      return try await (ShopCall?.totalSupply(contractAddress: contract))!
   }
   
  
    public func transfer(to: EthereumAddress,amount: BigUInt, account: EthereumAccount) async throws -> String{
      let gasPrice = try await client.eth_gasPrice()
      let transaction = try await (ShopCall?.transfer(contractAddress:contract,to: to,amount: amount, from: account.address, gasPrice: gasPrice))!
      let txHash = try await client.eth_sendRawTransaction(transaction, withAccount: account)
      return txHash
   }
      
}
extension Shop {
  public func allowance(contractAddress: EthereumAddress, owner: EthereumAddress, spender: EthereumAddress,  completionHandler: @escaping (Result<BigUInt, Error>) -> Void) {
    Task {
        do {
            let allowance = try await allowance(contractAddress: contractAddress , owner: owner, spender: spender)
            completionHandler(.success(allowance))
        } catch {
            completionHandler(.failure(error))
        }
    }
}
  public func balanceOf(contractAddress: EthereumAddress, account: EthereumAddress,  completionHandler: @escaping (Result<BigUInt, Error>) -> Void) {
    Task {
        do {
            let balanceOf = try await balanceOf(contractAddress: contractAddress , account: account)
            completionHandler(.success(balanceOf))
        } catch {
            completionHandler(.failure(error))
        }
    }
}
  public func decimals(contractAddress: EthereumAddress,  completionHandler: @escaping (Result<BigUInt, Error>) -> Void) {
    Task {
        do {
            let decimals = try await decimals(contractAddress: contractAddress )
            completionHandler(.success(decimals))
        } catch {
            completionHandler(.failure(error))
        }
    }
}
  public func name(contractAddress: EthereumAddress,  completionHandler: @escaping (Result<String, Error>) -> Void) {
    Task {
        do {
            let name = try await name(contractAddress: contractAddress )
            completionHandler(.success(name))
        } catch {
            completionHandler(.failure(error))
        }
    }
}
  public func owner(contractAddress: EthereumAddress,  completionHandler: @escaping (Result<EthereumAddress, Error>) -> Void) {
    Task {
        do {
            let owner = try await owner(contractAddress: contractAddress )
            completionHandler(.success(owner))
        } catch {
            completionHandler(.failure(error))
        }
    }
}
  public func shopAddress(contractAddress: EthereumAddress,  completionHandler: @escaping (Result<String, Error>) -> Void) {
    Task {
        do {
            let shopAddress = try await shopAddress(contractAddress: contractAddress )
            completionHandler(.success(shopAddress))
        } catch {
            completionHandler(.failure(error))
        }
    }
}
  public func shopPhoneNumber(contractAddress: EthereumAddress,  completionHandler: @escaping (Result<String, Error>) -> Void) {
    Task {
        do {
            let shopPhoneNumber = try await shopPhoneNumber(contractAddress: contractAddress )
            completionHandler(.success(shopPhoneNumber))
        } catch {
            completionHandler(.failure(error))
        }
    }
}
  public func shopWebsite(contractAddress: EthereumAddress,  completionHandler: @escaping (Result<String, Error>) -> Void) {
    Task {
        do {
            let shopWebsite = try await shopWebsite(contractAddress: contractAddress )
            completionHandler(.success(shopWebsite))
        } catch {
            completionHandler(.failure(error))
        }
    }
}
  public func symbol(contractAddress: EthereumAddress,  completionHandler: @escaping (Result<String, Error>) -> Void) {
    Task {
        do {
            let symbol = try await symbol(contractAddress: contractAddress )
            completionHandler(.success(symbol))
        } catch {
            completionHandler(.failure(error))
        }
    }
}
  public func totalSupply(contractAddress: EthereumAddress,  completionHandler: @escaping (Result<BigUInt, Error>) -> Void) {
    Task {
        do {
            let totalSupply = try await totalSupply(contractAddress: contractAddress )
            completionHandler(.success(totalSupply))
        } catch {
            completionHandler(.failure(error))
        }
    }
}
}
