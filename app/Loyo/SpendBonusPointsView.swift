//
//  SpendBonusPointsView.swift
//  Loyo
//
//  Created by Nikita TEREKHOV on 13/05/2023.
//

import SwiftUI
import BigInt





public struct MockShopItem: Identifiable {
    public let id = UUID()
    public let balance: String
    var name: String
    var verbose_id: String
}



// a view presenting multiple shops where the user has some points

struct SpendBonusPointsView: View {
    @State var tokenSelected: Bool
    @State var selectedShopId: UUID?
    
    @StateObject var blockchainConnector = BlockchainConnector.shared
    
    
    @State var shops = [
        MockShopItem(
            balance: "0",
            name: "Ethereum Pizza Service", verbose_id: "eps")
    ]
    
    @State var pizzaShopBalance: String = "0"

    var body: some View {
        VStack {
            Text("Spend Bonus Points")
                .font(Font.system(size: 24))
                .multilineTextAlignment(.center)
                .foregroundStyle(
                    
                    LinearGradient(
                        gradient: Gradient(colors: [Color.init(hex: "99EDCC"), Color.init(hex: "0099F8")]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .padding(15)
                .padding(.vertical, 30)
            
            ForEach(shops) { item in
                HStack {
                    Text(item.name)
                        .font(.headline)
                        .foregroundColor(Color.init(hex: "1b264f"))

                    Spacer()
                    
                    Text(pizzaShopBalance.prefix(3))
                        .font(Font.system(size: 15))
                        .foregroundColor(Color.init(hex: "0099F8"))
                        .task {
                            do {
                                let fetchedBalance = try await blockchainConnector.getShopBalance(
                                    shopContractAddress: TEST_SHOP_TOKEN_ADDRESS
                                )
                                pizzaShopBalance = fetchedBalance
                            }
                            catch {
                                pizzaShopBalance = "30"
                            }
                        }

                }
                .padding(.horizontal, 35)
                .padding(.vertical, 10)
                .onTapGesture {
                    tokenSelected.toggle()
                    selectedShopId = item.id
                }
            }
            Spacer()
        }
        .sheet(isPresented: $tokenSelected) {
            SelectedTokenView(
                selectedShopId: $selectedShopId,
                shops: blockchainConnector.shops
            )
        }
    }
}
