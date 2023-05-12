//
//  ContentView.swift
//  Loyo
//
//  Created by Kirill on 5/2/23.
//

import SwiftUI
import CryptoSwift


struct ContentView: View {
    @State var selectedToken: Bool = false
    @State var selectedTokenName: String = ""
    @State var publicKey: String = ""
    @State var chosenShopBalance: Double = 0
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.init(hex: "99EDCC"), Color.init(hex: "0099F8")]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack {
                    Text("Get Bonus Points")
                        .font(.system(size:36))
                                        
                    Image("qr-code-dynamic(3)")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.green)
                        .clipped()
                        .padding(.horizontal, 20)
                }
                .padding(.vertical, 30)
                VStack {
                    Text("Spend Bonus Points")
                        .font(Font.system(size: 36))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(

                            LinearGradient(
                                gradient: Gradient(colors: [Color.init(hex: "99EDCC"), Color.init(hex: "0099F8")]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                        )
                        .padding(15)
                                        
                    ForEach(items, id: \.id) { item in
                        Divider()
                        HStack {
                            Text(item.name)
                                    .font(.headline)
                                    .foregroundColor(Color.init(hex: "1b264f"))
                            
                            Spacer()
                            Text(String(item.balance))
                                    .font(Font.system(size: 15))
                                    .foregroundColor(Color.init(hex: "0099F8"))
                            
                        }
                        .padding(.horizontal, 35)
                        .padding(.vertical, 10)
                        .onTapGesture {
                            selectedToken.toggle()
                            selectedTokenName = item.name
                            chosenShopBalance = item.balance
                        }
                    }
                } .background(Color.white).ignoresSafeArea()
                    .cornerRadius(15)
                }
            .sheet(isPresented: $selectedToken) {
                SelectedTokenView(tokenName: self.selectedTokenName, balance: self.chosenShopBalance)
            }
        }
    }
}


struct SelectedTokenView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var tokenName: String
    @State var balance: Double
    @State var chosenRealWorldAssetId: UUID? = nil
    @State private var isPresentingConfirm: Bool = false
    @State var transactionPending = false
    @State var transactionSuccess = false

    var body: some View {
        VStack {
            HStack{
                Button("Back") {
                    presentationMode.wrappedValue.dismiss()
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            
            Text(self.tokenName)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.vertical, 20)
            
            
            Text("Balance:")
                .font(Font.system(size: 18))
            Text(String(format: "%g", self.balance))
                .font(Font.system(size: 30))
            
            TabView {
                VStack{
                    if chosenRealWorldAssetId != nil {
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
                                            Text(String(chosenAssetItem.price))
                                            Text("Spend!")
                                        }
                                        .fixedSize()
                                    })
                                        .buttonStyle(.borderedProminent)
                                        .tint(Color.init(hex: "99edcc"))
                                        .foregroundColor(Color.black)
                                        .confirmationDialog("Are you sure?",
                                          isPresented: $isPresentingConfirm) {
                                            Button("Spend \(String(format: "%g", chosenAssetItem.price)) tokens for \(chosenAssetItem.name) ?") {
                                                transactionPending = true
                                                self.balance = balance - chosenAssetItem.price
                                                let timer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: false) { _ in
                                                    transactionPending = false
                                                    transactionSuccess = true
                                                    let timer2 = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { __ in
                                                        transactionSuccess = false
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
                    ScrollView {
                        VStack {
                            ForEach(realWorldAssets, id: \.id) { item in
                                Divider()
                                HStack {
                                    Text(item.name)
                                            .font(.headline)
                                            .foregroundColor(Color.init(hex: "1b264f"))
                                    
                                    Spacer()
                                    Text(String(item.price))
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
                .tabItem {
                    Label("Spend Tokens", systemImage: "banknote")
                }
                SendTokenToFriendView()
                    .tabItem {
                        Label("Gift Friend", systemImage: "gift")
                    }
            }
            .accentColor(Color.init(hex: "d14081"))
        }.padding(.top, 20)
    }
}


struct RealWorldAsset: Identifiable {
    let id = UUID()
    let icon: String
    let name: String
    let price: Double
}

let realWorldAssets = [
    RealWorldAsset(icon: "cup", name: "Latte", price: 3.99),
    RealWorldAsset(icon: "coffee", name: "Espresso", price: 2.99),
    RealWorldAsset(icon: "drop", name: "Cappuccino", price: 4.49),
    RealWorldAsset(icon: "teapot", name: "Tea", price: 2.99),
    RealWorldAsset(icon: "milk", name: "Milkshake", price: 5.49),
    RealWorldAsset(icon: "cup", name: "Latte", price: 3.99),
    RealWorldAsset(icon: "coffee", name: "Espresso", price: 2.99),
    RealWorldAsset(icon: "drop", name: "Cappuccino", price: 4.49),
    RealWorldAsset(icon: "teapot", name: "Tea", price: 2.99),
    RealWorldAsset(icon: "milk", name: "Milkshake", price: 5.49),
    RealWorldAsset(icon: "flame", name: "Hot Chocolate", price: 4.99)
]

struct Item: Identifiable {
    let id = UUID()
    let icon: String
    let name: String
    let balance: Double
}

let items = [
    Item(icon: "My Favourite Bar", name: "My Favourite Bar", balance: 89),
    Item(icon: "banknote", name: "A Shop Nearby", balance: 150),
    Item(icon: "creditcard", name: "Coffee Shop", balance: 160),
    Item(icon: "banknote", name: "Gaming Store", balance: 170),
    Item(icon: "My Favourite Bar", name: "My Favourite Bar", balance: 89),
    Item(icon: "banknote", name: "A Shop Nearby", balance: 89),
    Item(icon: "creditcard", name: "Coffee Shop", balance: 89),
    Item(icon: "My Favourite Bar", name: "My Favourite Bar", balance: 89),
    Item(icon: "banknote", name: "A Shop Nearby", balance: 89),
    Item(icon: "creditcard", name: "Coffee Shop", balance: 89),
    Item(icon: "creditcard", name: "Online Learning Platform", balance: 89)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}

//func getPublicKey() -> String {
//    let address = UserDefaults.standard.string(forKey: "address")
//    if address == nil {
//        let privateKey = generateRandomPrivateKey()
//        let publicKey = try! PublicKeyFromPrivateKey(privateKey: privateKey)
//        let address = try! Keccak256().hash(publicKey.data())
//        UserDefaults.standard.set(publicKey, forKey:"PublicKey")
//        UserDefaults.standard.set(privateKey, forKey: "PrivateKey")
//        UserDefaults.standard.set(address, forKey: "address")
//        return address
//    }
//    else {
//        return address!
//    }
//}

//
//fileprivate func createMnemonics() {
//    let userDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//    let web3KeystoreManager = KeystoreManager.managerForPath(userDir + "/keystore")
//    do {
//        if web3KeystoreManager?.addresses?.count ?? 0 >= 0 {
//            let tempMnemonics = try? BIP39.generateMnemonics(bitsOfEntropy: 256, language: .english)
//            let tempWalletAddress = try? BIP32Keystore(mnemonics: tempMnemonics!, password: "", prefixPath: "m/44'/77777'/0'/0")
//            guard let walletAddress = tempWalletAddress?.addresses?.first else {
//                self.showAlertMessage(title: "", message: "Unable to create wallet", actionName: "Ok")
//                return
//            }
//            self._walletAddress = walletAddress.address
//            let privateKey = try tempWalletAddress?.UNSAFE_getPrivateKeyData(password: "", account: walletAddress)
//#if DEBUG
//            print(privateKey, "Is the private key")
//#endif
//            let keyData = try? JSONEncoder().encode(tempWalletAddress?.keystoreParams)
//            FileManager.default.createFile(atPath: userDir + "/keystore" + "/key.json", contents: keyData, attributes: nil)
//        }
//    } catch {
//
//    }
//
//}
