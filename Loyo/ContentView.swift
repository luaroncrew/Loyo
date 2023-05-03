//
//  ContentView.swift
//  Loyo
//
//  Created by Kirill on 5/2/23.
//

import SwiftUI
import CryptoSwift


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
.previewInterfaceOrientation(.portrait)
    }
}

struct ContentView: View {
    @State var selectedToken: Bool = true
    @State var selectedTokenName: String = ""
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
                            
                            Spacer()
                            Text(String(item.balance))
                                    .font(Font.system(size: 15))
                                    .foregroundColor(Color.init(hex: "0099F8"))
                            
                        }
                        .padding(.horizontal, 35)
                        .padding(.vertical, 10)
                        .onTapGesture {
                            selectedTokenName = item.name
                            selectedToken.toggle()
                        }
                        }
                } .background(Color.white).ignoresSafeArea()
                    .cornerRadius(15)
                }
            .sheet(isPresented: $selectedToken) {
                SelectedTokenView(tokenName: selectedTokenName)
            }
            }
        }
    }

struct Item: Identifiable {
    let id = UUID()
    let icon: String
    let name: String
    let balance: Double
}

let items = [
    Item(icon: "My Favourite Bar", name: "My Favourite Bar", balance: 12),
    Item(icon: "banknote", name: "A Shop Nearby", balance: 64),
    Item(icon: "creditcard", name: "Coffee Shop", balance: 89),
    Item(icon: "banknote", name: "Gaming Store", balance: 13),
    Item(icon: "My Favourite Bar", name: "My Favourite Bar", balance: 12),
    Item(icon: "banknote", name: "A Shop Nearby", balance: 64),
    Item(icon: "creditcard", name: "Coffee Shop", balance: 89),
    Item(icon: "creditcard", name: "Online Learning Platform", balance: 123)
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


struct SelectedTokenView: View {
    @Environment(\.presentationMode) var presentationMode
    let tokenName: String
    let tokenBalance: Int =  Int.random(in: 1..<150)
    
    func getTokenName(name: String) -> String {
        if name == "" {
            return "Sample shop"
        }
        else {
            return name
        }
    }
    
    var body: some View {
        VStack {
            HStack{
                Button("Back") {
                    presentationMode.wrappedValue.dismiss()
                }
                Spacer()
            }
            
            Text(getTokenName(name: tokenName))
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.vertical, 20)
            
            
            Text("Balance:")
                .font(Font.system(size: 18))
            Text(String(tokenBalance))
                .font(Font.system(size: 30))
            
            Text("Choose your good:")
                .padding(.top, 40)
            
            TabView {
                ScrollView {
                    VStack {
                        ForEach(realWorldAssets, id: \.id) { item in
                            Divider()
                            HStack {
                                Text(item.name)
                                        .font(.headline)
                                
                                Spacer()
                                Text(String(item.price))
                                        .font(Font.system(size: 15))
                                        .foregroundColor(Color.init(hex: "0099F8"))
                                
                            }
                            .padding(.horizontal, 35)
                            .padding(.vertical, 10)
                            }
                    }
                }.tabItem {
                    Label("Spend Tokens", systemImage: "banknote")
                }
                Text("2")
                    .tabItem {
                        Label("Gift Friend", systemImage: "gift")
                    }
            }
                    
        }
        .padding()
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
