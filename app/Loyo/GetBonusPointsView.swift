//
//  BonusPointsView.swift
//  Loyo
//
//  Created by Nikita TEREKHOV on 13/05/2023.
//



import SwiftUI
import EFQRCode

struct GetBonusPointsView: View {
    
    @State public var userEnsName: String = ""
    @StateObject var blockchainConnector = BlockchainConnector.shared
    @State var showUsernameField: Bool = false
    @State var usernameSubmitted: Bool = false
    @State var usernameInputText: String = ""
    
    var body: some View {
        VStack {
            if userEnsName != "" {
                Text("Good morning, \(userEnsName)")
                    .font(Font.system(size: 24))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.white)
                    .padding(.top, 20)
            } else {
                Text("Get Bonus Points")
                    .font(Font.system(size: 24))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.white)
                    .padding(.top, 20)
            }
                                
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
                Text("Show this QR code to merchants when you want to receive loyalty points")
                    .padding(.top, 20)
                    .padding(.horizontal, 50)
                
                VStack {
                    if showUsernameField == false && userEnsName == "" {
                        Button("Add username") {
                            showUsernameField.toggle()
                        }
                    }
                    if showUsernameField {
                        VStack{
                            TextField("loyalty_enjoyer", text: $usernameInputText)
                                .multilineTextAlignment(.center)
                            if usernameInputText != "" {
                                Button("Submit username") {
                                    // register ENS domain name (like in workshop)
                                    userEnsName = usernameInputText
                                    showUsernameField = false
                                }
                            }
                        }
                    }
                }
                    .padding(.top, 60)
            } else {
                // Show a loading indicator or a placeholder while the account is being initialized
                Text("Loading...")
            }
            Spacer()

        }
        .padding(.vertical, 30)
    }
}

