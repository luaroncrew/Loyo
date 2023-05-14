
//
//  swiftAbi
//  Don't change the files! this file is generated!
//  https://github.com/imanrep/
//

import BigInt
import Foundation
import web3

public enum ShopResponses {
  public struct allowanceResponse: ABIResponse, MulticallDecodableResponse {
    public static var types: [ABIType.Type] = [BigUInt.self]
    public let value: BigUInt
    
    public init?(values: [ABIDecoder.DecodedValue]) throws {

      self.value = try values[0].decoded()
      
    }
}
  public struct balanceOfResponse: ABIResponse, MulticallDecodableResponse {
    public static var types: [ABIType.Type] = [BigUInt.self]
    public let value: BigUInt
    
    public init?(values: [ABIDecoder.DecodedValue]) throws {

      self.value = try values[0].decoded()
      
    }
}
  public struct decimalsResponse: ABIResponse, MulticallDecodableResponse {
    public static var types: [ABIType.Type] = [BigUInt.self]
    public let value: BigUInt
    
    public init?(values: [ABIDecoder.DecodedValue]) throws {

      self.value = try values[0].decoded()
      
    }
}
  public struct nameResponse: ABIResponse, MulticallDecodableResponse {
    public static var types: [ABIType.Type] = [String.self]
    public let value: String
    
    public init?(values: [ABIDecoder.DecodedValue]) throws {

      self.value = try values[0].decoded()
      
    }
}
  public struct ownerResponse: ABIResponse, MulticallDecodableResponse {
    public static var types: [ABIType.Type] = [EthereumAddress.self]
    public let value: EthereumAddress
    
    public init?(values: [ABIDecoder.DecodedValue]) throws {

      self.value = try values[0].decoded()
      
    }
}
  public struct shopAddressResponse: ABIResponse, MulticallDecodableResponse {
    public static var types: [ABIType.Type] = [String.self]
    public let value: String
    
    public init?(values: [ABIDecoder.DecodedValue]) throws {

      self.value = try values[0].decoded()
      
    }
}
  public struct shopPhoneNumberResponse: ABIResponse, MulticallDecodableResponse {
    public static var types: [ABIType.Type] = [String.self]
    public let value: String
    
    public init?(values: [ABIDecoder.DecodedValue]) throws {

      self.value = try values[0].decoded()
      
    }
}
  public struct shopWebsiteResponse: ABIResponse, MulticallDecodableResponse {
    public static var types: [ABIType.Type] = [String.self]
    public let value: String
    
    public init?(values: [ABIDecoder.DecodedValue]) throws {

      self.value = try values[0].decoded()
      
    }
}
  public struct symbolResponse: ABIResponse, MulticallDecodableResponse {
    public static var types: [ABIType.Type] = [String.self]
    public let value: String
    
    public init?(values: [ABIDecoder.DecodedValue]) throws {

      self.value = try values[0].decoded()
      
    }
}
  public struct totalSupplyResponse: ABIResponse, MulticallDecodableResponse {
    public static var types: [ABIType.Type] = [BigUInt.self]
    public let value: BigUInt
    
    public init?(values: [ABIDecoder.DecodedValue]) throws {

      self.value = try values[0].decoded()
      
    }
}

}
