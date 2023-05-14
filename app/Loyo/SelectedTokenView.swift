//
//  SelectedTokenView.swift
//  Loyo
//
//  Created by Nikita TEREKHOV on 13/05/2023.
//

import SwiftUI
import BigInt

struct SelectedTokenView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedShopId: UUID?
    var shops: [ShopItem]
    
    @State var chosenRealWorldAssetId: UUID? = nil
    @State private var isPresentingConfirm: Bool = false
    @State var transactionPending = false
    @State var transactionSuccess = false
    
    @State private var isPresentingSendTokenToFriendView = false

    
    @StateObject var blockchainConnector = BlockchainConnector.shared

    var body: some View {
        NavigationView {
            
            VStack {
                //            HStack{
                //                Button("Back") {
                //                    presentationMode.wrappedValue.dismiss()
                //                }
                //                Spacer()
                //            }
                //            .padding(.horizontal, 20)
                
                HStack{
                    Button("Back") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    Spacer()
                    NavigationLink(destination: SendTokenToFriendView()) {
                        HStack {
                            Image(systemName: "gift")
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text("Gift Friend")
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                    }
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                
                
                if let selectedShopId = selectedShopId {
                    
                    if let shopItem = shops.first(where: { $0.id == selectedShopId }) {
                        Text(shopItem.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.vertical, 20)
                        
                        Text("Balance:")
                            .font(Font.system(size: 18))
                        Text(convertToString(amount: shopItem.balance, decimals: 2))
                            .font(Font.system(size: 30))
                    } else {
                        Text("Shop Item Not Found")
                            .font(Font.system(size: 30))
                    }
                } else {
                    Text("No Shop Item Selected")
                        .font(Font.system(size: 30))
                }
                
                TabView {
                    VStack{
                        if let selectedShopId = selectedShopId, let shopItem = shops.first(where: { $0.id == selectedShopId }) {
                            if let chosenAssetItem = realWorldAssets.first(where: { $0.id == chosenRealWorldAssetId }) {
                                HStack {
                                    Text(String(chosenAssetItem.name))
                                        .foregroundColor(Color.init(hex: "1b264f"))
                                    Spacer()
                                    if transactionPending {
                                        Text("Transaction pending")
                                            .foregroundColor(Color.init(hex: "ffad69"))
                                        Spacer()
                                        ProgressView()
                                    }
                                    else if transactionSuccess {
                                        Text("Transaction Success!")
                                            .foregroundColor(Color.init(hex: "99edcc"))
                                        Spacer()
                                        Image(systemName: "checkmark")
                                    }
                                    else {
                                        Button (action: {
                                            isPresentingConfirm = true
                                        }, label: {
                                            HStack {
                                                Image(systemName: "dollarsign.circle")
                                                Text(convertToString(amount: chosenAssetItem.price, decimals: 2))
                                                Text("Spend!")
                                            }
                                            .fixedSize()
                                        })
                                        .buttonStyle(.borderedProminent)
                                        .tint(Color.init(hex: "99edcc"))
                                        .foregroundColor(Color.black)
                                        .confirmationDialog("Are you sure?",
                                                            isPresented: $isPresentingConfirm) {
                                            Button("Spend \(convertToString(amount: chosenAssetItem.price, decimals: 2)) tokens for \(chosenAssetItem.name) ?") {
                                                transactionPending = true
                                                
                                                Task.init {
                                                    do {
                                                        //                                                        try await blockchainConnector.executePayment(shopContractAddress: shopItem.shopContractAddress, amount: BigUInt(chosenAssetItem.price))
                                                        try await blockchainConnector.executePayment(shopContractAddress: shopItem.shopContractAddress, amount: chosenAssetItem.price)
                                                        try await blockchainConnector.updateShopBalance(shopContractAddress: shopItem.shopContractAddress)
                                                        transactionPending = false
                                                        transactionSuccess = true
                                                        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { __ in
                                                            transactionSuccess = false
                                                        }
                                                    } catch {
                                                        print("Transaction failed: \(error)")
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal, 35)
                            }
                        }
                        Text("Choose your good:")
                            .font(Font.system(size: 24))
                        
                        ScrollView {
                            VStack {
                                ForEach(realWorldAssets, id: \.id) { item in
                                    Divider()
                                    HStack {
                                        Text(item.name)
                                            .font(.headline)
                                            .foregroundColor(Color.init(hex: "1b264f"))
                                        
                                        Spacer()
                                        Text(convertToString(amount: item.price, decimals: 2))
                                            .font(Font.system(size: 15))
                                            .foregroundColor(Color.init(hex: "0099f8"))
                                        
                                    }
                                    .padding(.horizontal, 35)
                                    .padding(.vertical, 10)
                                    .onTapGesture {
                                        chosenRealWorldAssetId = item.id
                                    }
                                }
                            }
                        }
                    }
                    //                SendTokenToFriendView()
                    //                    .tabItem {
                    //                        Label("Gift Friend", systemImage: "gift")
                    //                    }
                }
                .accentColor(Color.init(hex: "d14081"))
            }.padding(.top, 20)
        }
    }
}


struct RealWorldAsset: Identifiable {
    let id = UUID()
    let icon: String
    let name: String
    let price: BigUInt
}

let realWorldAssets = [
    RealWorldAsset(icon: "cup", name: "Latte", price: BigUInt(399)),
    RealWorldAsset(icon: "coffee", name: "Espresso", price: BigUInt(299)),
    RealWorldAsset(icon: "drop", name: "Cappuccino", price: BigUInt(449)),
    RealWorldAsset(icon: "teapot", name: "Tea", price: BigUInt(299)),
    RealWorldAsset(icon: "milk", name: "Milkshake", price: BigUInt(549)),
    RealWorldAsset(icon: "cup", name: "Latte", price: BigUInt(399)),
    RealWorldAsset(icon: "coffee", name: "Espresso", price: BigUInt(299)),
    RealWorldAsset(icon: "drop", name: "Cappuccino", price: BigUInt(449)),
    RealWorldAsset(icon: "teapot", name: "Tea", price: BigUInt(299)),
    RealWorldAsset(icon: "milk", name: "Milkshake", price: BigUInt(549)),
    RealWorldAsset(icon: "flame", name: "Hot Chocolate", price: BigUInt(499))
]


func getUserWalletAddress() -> String {
    return "0x6B45151E6F052177838f024d6a25C4c29a159231"
}


extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

