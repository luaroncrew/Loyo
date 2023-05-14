
//
//  swiftAbi
//  Don't change the files! this file is generated!
//  https://github.com/imanrep/
//

import BigInt
import Foundation
import web3

public enum ShopAggregatorResponses {
  public struct getAllShopsResponse: ABIResponse, MulticallDecodableResponse {
    public static var types: [ABIType.Type] = [ABIArray<EthereumAddress>.self]
    public let value: [EthereumAddress]
    
    public init?(values: [ABIDecoder.DecodedValue]) throws {

      self.value = try values[0].decodedArray()
      
    }
}
  public struct ownerResponse: ABIResponse, MulticallDecodableResponse {
    public static var types: [ABIType.Type] = [EthereumAddress.self]
    public let value: EthereumAddress
    
    public init?(values: [ABIDecoder.DecodedValue]) throws {

      self.value = try values[0].decoded()
      
    }
}
  public struct shopsResponse: ABIResponse, MulticallDecodableResponse {
    public static var types: [ABIType.Type] = [EthereumAddress.self]
    public let value: EthereumAddress
    
    public init?(values: [ABIDecoder.DecodedValue]) throws {

      self.value = try values[0].decoded()
      
    }
}

}
