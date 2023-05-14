//
//  AccountQRCodeView.swift
//  Loyo
//
//  Created by Nikita TEREKHOV on 13/05/2023.
//

import SwiftUI
import EFQRCode

struct AccountQRCodeView: View {
    @ObservedObject var blockchainConnector: BlockchainConnector
    
    var body: some View {
        if blockchainConnector.isAccountInitialized {
            if let cgImage = EFQRCode.generate(
                content: blockchainConnector.account?.address.asString() ?? "error",
                watermark: nil
            ) {
                Image(uiImage: UIImage(cgImage: cgImage))
                    .resizable()
                    .frame(width: 200, height: 200)
            } else {
                Image(systemName: "xmark.circle") // Or some other placeholder image
            }
        } else {
            // Show a loading indicator or a placeholder while the account is being initialized
            Text("Loading...")
        }
    }
}

