//
//  BonusPointsView.swift
//  Loyo
//
//  Created by Nikita TEREKHOV on 13/05/2023.
//

import SwiftUI
import EFQRCode

struct GetBonusPointsView: View {
    
    @StateObject var blockchainConnector = BlockchainConnector.shared
    
    var body: some View {
        VStack {
            Text("Get Bonus Points")
                .font(Font.system(size: 24))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.white)
                .padding(.top, 20)
            

                                
            if blockchainConnector.isAccountInitialized {
                if let cgImage = EFQRCode.generate(
                     content: blockchainConnector.account?.address.asString() ?? "error",
                     backgroundColor: CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.0)
                ) {
                    Image(uiImage: UIImage(cgImage: cgImage))
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.green)
                        .clipped()
                        .padding(.horizontal, 40)
                } else {
                    Image(systemName: "xmark.circle") // Or some other placeholder image
                }
            } else {
                // Show a loading indicator or a placeholder while the account is being initialized
                Text("Loading...")
            }
            Spacer()

        }
        .padding(.vertical, 30)
    }
}

