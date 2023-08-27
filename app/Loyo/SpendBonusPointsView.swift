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
    var balance: UInt8
    var name: String
    var verbose_id: String
}



// a view presenting multiple shops where the user has some points

struct SpendBonusPointsView: View {
    @State var tokenSelected: Bool
    @State var selectedShopId: UUID?
    
    @StateObject var blockchainConnector = BlockchainConnector.shared
    
    var shops = [
        MockShopItem(balance: 100, name: "Ethereum Pizza Service", verbose_id: "eps")
    ]

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
            
            
            
            ForEach(shops) { item in
                HStack {
                    Text(item.name)
                        .font(.headline)
                        .foregroundColor(Color.init(hex: "1b264f"))

                    Spacer()
                    
                    Text("\(item.balance)")
                        .font(Font.system(size: 15))
                        .foregroundColor(Color.init(hex: "0099F8"))

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
