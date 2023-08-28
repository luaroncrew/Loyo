import SwiftUI
import BigInt

struct SelectedTokenView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedShopId: UUID?
    var shops: [ShopItem]
    
    @State var chosenRealWorldAsset: RealWorldAsset? = nil
    @State private var isPresentingConfirm: Bool = false
    @State var transactionPending = false
    @State var transactionSuccess = false
    @State var selectedShopBalance = "0"
    
    @State private var isPresentingSendTokenToFriendView = false
    
    
    @StateObject var blockchainConnector = BlockchainConnector.shared
    
    var body: some View {
        NavigationView {
            VStack {
                
                // header with buttons
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
                .padding(.vertical, 10)
                
                // selected shop and balance
                Text("Ethereum Pizza Service")
                    .font(Font.system(size: 30))
                Text("Balance:")
                    .font(Font.system(size: 18))
                Text(selectedShopBalance.prefix(4))
                    .font(Font.system(size: 30))
                    .task {
                        do {
                            let fetchedBalance = try await blockchainConnector.getShopBalance(
                                shopContractAddress: TEST_SHOP_TOKEN_ADDRESS
                            )
                            selectedShopBalance = fetchedBalance
                        } catch {
                            selectedShopBalance = "0"
                        }
                    }
                
                // chosen item and button to buy it
                HStack {
                    if let realWorldAsset = chosenRealWorldAsset {
                        Text(String(realWorldAsset.name))
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
                                    Text("\(realWorldAsset.price)")
                                    Text("Spend!")
                                }
                                .fixedSize()
                            }).buttonStyle(.borderedProminent)
                                .tint(Color.init(hex: "99edcc"))
                                .foregroundColor(Color.black)
                                .confirmationDialog(
                                    "Are you sure?",
                                    isPresented: $isPresentingConfirm
                                ) {
                                    Button("Spend \(realWorldAsset.price) tokens for \(realWorldAsset.name) ?") {
                                        transactionPending = true
                                        Task.init {
                                            do {
                                                try await blockchainConnector.executePayment(
                                                    shopContractAddress: TEST_SHOP_TOKEN_ADDRESS,
                                                    amount: realWorldAsset.price
                                                )
                                                let fetchedBalance = try await blockchainConnector.getShopBalance(
                                                    shopContractAddress: TEST_SHOP_TOKEN_ADDRESS
                                                )
                                                selectedShopBalance = fetchedBalance

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
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                // item choice scroll menu
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
                                Text("\(item.price)")
                                    .font(Font.system(size: 15))
                                    .foregroundColor(Color.init(hex: "0099f8"))
                                
                            }
                            .padding(.horizontal, 35)
                            .padding(.vertical, 10)
                            .onTapGesture {
                                chosenRealWorldAsset = item
                            }
                        }
                    }
                }
            }
        }
    }
}

struct RealWorldAsset: Identifiable {
    let id = UUID()
    let icon: String
    let name: String
    let price: Int
}

let realWorldAssets = [
    RealWorldAsset(icon: "cup", name: "Latte", price: 3),
    RealWorldAsset(icon: "coffee", name: "Espresso", price: 5),
    RealWorldAsset(icon: "drop", name: "Cappuccino", price: 8),
    RealWorldAsset(icon: "teapot", name: "Tea", price: 11),
    RealWorldAsset(icon: "cup", name: "Latte", price: 3),
    RealWorldAsset(icon: "coffee", name: "Espresso", price: 5),
    RealWorldAsset(icon: "drop", name: "Cappuccino", price: 8),
    RealWorldAsset(icon: "teapot", name: "Tea", price: 11),
    RealWorldAsset(icon: "cup", name: "Latte", price: 3),
    RealWorldAsset(icon: "coffee", name: "Espresso", price: 5),
    RealWorldAsset(icon: "drop", name: "Cappuccino", price: 8),
    RealWorldAsset(icon: "teapot", name: "Tea", price: 11)
]

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


                                                    
