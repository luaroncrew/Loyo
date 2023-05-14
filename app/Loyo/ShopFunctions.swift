
//
//  swiftAbi
//  Don't change the files! this file is generated!
//  https://github.com/imanrep/
//

import BigInt
import Foundation
import web3

public enum ShopFunctions {
  public struct allowance: ABIFunction {
    public static let name = "allowance"
    public let gasPrice: BigUInt?
    public let gasLimit: BigUInt?
    public var contract: EthereumAddress
    public let from: EthereumAddress?

    public let owner: EthereumAddress
    public let spender: EthereumAddress
    

    public init(
        contract: EthereumAddress,
        from: EthereumAddress? = nil,
        gasPrice: BigUInt? = nil,
        gasLimit: BigUInt? = nil,
        owner: EthereumAddress,
        spender: EthereumAddress
        
    ) {
        self.contract = contract
        self.from = from
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        self.owner = owner
        self.spender = spender
        
    }

    public func encode(to encoder: ABIFunctionEncoder) throws {
      try encoder.encode(owner)
      try encoder.encode(spender)
      
    }
}
   public struct approve: ABIFunction {
    public static let name = "approve"
    public let gasPrice: BigUInt?
    public let gasLimit: BigUInt?
    public var contract: EthereumAddress
    public let from: EthereumAddress?

    public let spender: EthereumAddress
    public let amount: BigUInt
    

    public init(
        contract: EthereumAddress,
        from: EthereumAddress? = nil,
        gasPrice: BigUInt? = nil,
        gasLimit: BigUInt? = nil,
        spender: EthereumAddress,
        amount: BigUInt
        
    ) {
        self.contract = contract
        self.from = from
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        self.spender = spender
        self.amount = amount
        
    }

    public func encode(to encoder: ABIFunctionEncoder) throws {
      try encoder.encode(spender)
      try encoder.encode(amount)
      
    }
}
   public struct balanceOf: ABIFunction {
    public static let name = "balanceOf"
    public let gasPrice: BigUInt?
    public let gasLimit: BigUInt?
    public var contract: EthereumAddress
    public let from: EthereumAddress?

    public let account: EthereumAddress
    

    public init(
        contract: EthereumAddress,
        from: EthereumAddress? = nil,
        gasPrice: BigUInt? = nil,
        gasLimit: BigUInt? = nil,
        account: EthereumAddress
        
    ) {
        self.contract = contract
        self.from = from
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        self.account = account
        
    }

    public func encode(to encoder: ABIFunctionEncoder) throws {
      try encoder.encode(account)
      
    }
}
   public struct decimals: ABIFunction {
    public static let name = "decimals"
    public let gasPrice: BigUInt?
    public let gasLimit: BigUInt?
    public var contract: EthereumAddress
    public let from: EthereumAddress?

    

    public init(
        contract: EthereumAddress,
        from: EthereumAddress? = nil,
        gasPrice: BigUInt? = nil,
        gasLimit: BigUInt? = nil
        
    ) {
        self.contract = contract
        self.from = from
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        
    }

    public func encode(to encoder: ABIFunctionEncoder) throws {
      
    }
}
   public struct decreaseAllowance: ABIFunction {
    public static let name = "decreaseAllowance"
    public let gasPrice: BigUInt?
    public let gasLimit: BigUInt?
    public var contract: EthereumAddress
    public let from: EthereumAddress?

    public let spender: EthereumAddress
    public let subtractedValue: BigUInt
    

    public init(
        contract: EthereumAddress,
        from: EthereumAddress? = nil,
        gasPrice: BigUInt? = nil,
        gasLimit: BigUInt? = nil,
        spender: EthereumAddress,
        subtractedValue: BigUInt
        
    ) {
        self.contract = contract
        self.from = from
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        self.spender = spender
        self.subtractedValue = subtractedValue
        
    }

    public func encode(to encoder: ABIFunctionEncoder) throws {
      try encoder.encode(spender)
      try encoder.encode(subtractedValue)
      
    }
}
   public struct increaseAllowance: ABIFunction {
    public static let name = "increaseAllowance"
    public let gasPrice: BigUInt?
    public let gasLimit: BigUInt?
    public var contract: EthereumAddress
    public let from: EthereumAddress?

    public let spender: EthereumAddress
    public let addedValue: BigUInt
    

    public init(
        contract: EthereumAddress,
        from: EthereumAddress? = nil,
        gasPrice: BigUInt? = nil,
        gasLimit: BigUInt? = nil,
        spender: EthereumAddress,
        addedValue: BigUInt
        
    ) {
        self.contract = contract
        self.from = from
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        self.spender = spender
        self.addedValue = addedValue
        
    }

    public func encode(to encoder: ABIFunctionEncoder) throws {
      try encoder.encode(spender)
      try encoder.encode(addedValue)
      
    }
}
   public struct name: ABIFunction {
    public static let name = "name"
    public let gasPrice: BigUInt?
    public let gasLimit: BigUInt?
    public var contract: EthereumAddress
    public let from: EthereumAddress?

    

    public init(
        contract: EthereumAddress,
        from: EthereumAddress? = nil,
        gasPrice: BigUInt? = nil,
        gasLimit: BigUInt? = nil
        
    ) {
        self.contract = contract
        self.from = from
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        
    }

    public func encode(to encoder: ABIFunctionEncoder) throws {
      
    }
}
   public struct owner: ABIFunction {
    public static let name = "owner"
    public let gasPrice: BigUInt?
    public let gasLimit: BigUInt?
    public var contract: EthereumAddress
    public let from: EthereumAddress?

    

    public init(
        contract: EthereumAddress,
        from: EthereumAddress? = nil,
        gasPrice: BigUInt? = nil,
        gasLimit: BigUInt? = nil
        
    ) {
        self.contract = contract
        self.from = from
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        
    }

    public func encode(to encoder: ABIFunctionEncoder) throws {
      
    }
}
   public struct shopAddress: ABIFunction {
    public static let name = "shopAddress"
    public let gasPrice: BigUInt?
    public let gasLimit: BigUInt?
    public var contract: EthereumAddress
    public let from: EthereumAddress?

    

    public init(
        contract: EthereumAddress,
        from: EthereumAddress? = nil,
        gasPrice: BigUInt? = nil,
        gasLimit: BigUInt? = nil
        
    ) {
        self.contract = contract
        self.from = from
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        
    }

    public func encode(to encoder: ABIFunctionEncoder) throws {
      
    }
}
   public struct shopPhoneNumber: ABIFunction {
    public static let name = "shopPhoneNumber"
    public let gasPrice: BigUInt?
    public let gasLimit: BigUInt?
    public var contract: EthereumAddress
    public let from: EthereumAddress?

    

    public init(
        contract: EthereumAddress,
        from: EthereumAddress? = nil,
        gasPrice: BigUInt? = nil,
        gasLimit: BigUInt? = nil
        
    ) {
        self.contract = contract
        self.from = from
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        
    }

    public func encode(to encoder: ABIFunctionEncoder) throws {
      
    }
}
   public struct shopWebsite: ABIFunction {
    public static let name = "shopWebsite"
    public let gasPrice: BigUInt?
    public let gasLimit: BigUInt?
    public var contract: EthereumAddress
    public let from: EthereumAddress?

    

    public init(
        contract: EthereumAddress,
        from: EthereumAddress? = nil,
        gasPrice: BigUInt? = nil,
        gasLimit: BigUInt? = nil
        
    ) {
        self.contract = contract
        self.from = from
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        
    }

    public func encode(to encoder: ABIFunctionEncoder) throws {
      
    }
}
   public struct symbol: ABIFunction {
    public static let name = "symbol"
    public let gasPrice: BigUInt?
    public let gasLimit: BigUInt?
    public var contract: EthereumAddress
    public let from: EthereumAddress?

    

    public init(
        contract: EthereumAddress,
        from: EthereumAddress? = nil,
        gasPrice: BigUInt? = nil,
        gasLimit: BigUInt? = nil
        
    ) {
        self.contract = contract
        self.from = from
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        
    }

    public func encode(to encoder: ABIFunctionEncoder) throws {
      
    }
}
   public struct totalSupply: ABIFunction {
    public static let name = "totalSupply"
    public let gasPrice: BigUInt?
    public let gasLimit: BigUInt?
    public var contract: EthereumAddress
    public let from: EthereumAddress?

    

    public init(
        contract: EthereumAddress,
        from: EthereumAddress? = nil,
        gasPrice: BigUInt? = nil,
        gasLimit: BigUInt? = nil
        
    ) {
        self.contract = contract
        self.from = from
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        
    }

    public func encode(to encoder: ABIFunctionEncoder) throws {
      
    }
}
   public struct transfer: ABIFunction {
    public static let name = "transfer"
    public let gasPrice: BigUInt?
    public let gasLimit: BigUInt?
    public var contract: EthereumAddress
    public let from: EthereumAddress?

    public let to: EthereumAddress
    public let amount: BigUInt
    

    public init(
        contract: EthereumAddress,
        from: EthereumAddress? = nil,
        gasPrice: BigUInt? = nil,
        gasLimit: BigUInt? = nil,
        to: EthereumAddress,
        amount: BigUInt
        
    ) {
        self.contract = contract
        self.from = from
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        self.to = to
        self.amount = amount
        
    }

    public func encode(to encoder: ABIFunctionEncoder) throws {
      try encoder.encode(to)
      try encoder.encode(amount)
      
    }
}

}
