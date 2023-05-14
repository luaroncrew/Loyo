
//
//  swiftAbi
//  Don't change the files! this file is generated!
//  https://github.com/imanrep/
//

import BigInt
import Foundation
import web3

public protocol ShopAggregatorProtocol {
  init(client: EthereumClientProtocol)

  func getAllShops(contractAddress: EthereumAddress  ) async throws -> [EthereumAddress]
  func owner(contractAddress: EthereumAddress  ) async throws -> EthereumAddress
  func shops(contractAddress: EthereumAddress , : BigUInt ) async throws -> EthereumAddress
}

open class ShopAggregator: ShopAggregatorProtocol {
  let client: EthereumClientProtocol

  required public init(client: EthereumClientProtocol) {
      self.client = client
  }

  public func getAllShops(contractAddress: EthereumAddress ) async throws -> [EthereumAddress] {
    let function = ShopAggregatorFunctions.getAllShops(contract: contractAddress )
    let data = try await function.call(withClient: client, responseType: ShopAggregatorResponses.getAllShopsResponse.self)
    return data.value
}
  public func owner(contractAddress: EthereumAddress ) async throws -> EthereumAddress {
    let function = ShopAggregatorFunctions.owner(contract: contractAddress )
    let data = try await function.call(withClient: client, responseType: ShopAggregatorResponses.ownerResponse.self)
    return data.value
}
  public func shops(contractAddress: EthereumAddress , : BigUInt) async throws -> EthereumAddress {
    let function = ShopAggregatorFunctions.shops(contract: contractAddress , : )
    let data = try await function.call(withClient: client, responseType: ShopAggregatorResponses.shopsResponse.self)
    return data.value
}

}
open class ShopAggregatorContract {
  var ShopAggregatorCall: ShopAggregator?
  var client: EthereumClientProtocol
  var contract: web3.EthereumAddress
  
  init(contract: String, client: EthereumClientProtocol) {
      self.contract = EthereumAddress(contract)
      self.client = client
      self.ShopAggregatorCall = ShopAggregator(client: client)
      }
  public func getAllShops() async throws -> [EthereumAddress]{
      return try await (ShopAggregatorCall?.getAllShops(contractAddress: contract))!
   }
   
  public func owner() async throws -> EthereumAddress{
      return try await (ShopAggregatorCall?.owner(contractAddress: contract))!
   }
   
  public func shops(: BigUInt) async throws -> EthereumAddress{
      return try await (ShopAggregatorCall?.shops(contractAddress: contract, : ))!
   }
   
      
}
extension ShopAggregator {
  public func getAllShops(contractAddress: EthereumAddress,  completionHandler: @escaping (Result<[EthereumAddress], Error>) -> Void) {
    Task {
        do {
            let getAllShops = try await getAllShops(contractAddress: contractAddress )
            completionHandler(.success(getAllShops))
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
  public func shops(contractAddress: EthereumAddress, : BigUInt,  completionHandler: @escaping (Result<EthereumAddress, Error>) -> Void) {
    Task {
        do {
            let shops = try await shops(contractAddress: contractAddress , : )
            completionHandler(.success(shops))
        } catch {
            completionHandler(.failure(error))
        }
    }
}
}
