//
//  Utils.swift
//  Loyo
//
//  Created by Nikita TEREKHOV on 14/05/2023.
//

import BigInt

func convertToString(amount: BigUInt, decimals: Int) -> String {
    // Get the divisor (10^decimals)
    let divisor = BigUInt(10).power(decimals)

    // Perform the division
    let integerPart = amount / divisor
    let decimalPart = amount % divisor

    // Convert to strings
    let integerPartStr = String(integerPart)
    let decimalPartStr = String(decimalPart).padding(toLength: decimals, withPad: "0", startingAt: 0)

    // Join them together
    return integerPartStr + "." + decimalPartStr
}

