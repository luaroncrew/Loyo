//
//  SpendBonusPointsView.swift
//  Loyo
//
//  Created by Nikita TEREKHOV on 13/05/2023.
//

import SwiftUI
import BigInt

struct SpendBonusPointsView: View {
    @Binding var selectedToken: Bool
    @Binding var selectedShopId: UUID?
    
    var shops: [ShopItem]
    
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
            

            
            ForEach(shops, id: \.id) { item in
                Divider()
                HStack {
                    Text(item.name)
                            .font(.headline)
                            .foregroundColor(Color.init(hex: "1b264f"))
                    
                    Spacer()
                    Text(convertToString(amount: item.balance, decimals: 18))
                            .font(Font.system(size: 15))
                            .foregroundColor(Color.init(hex: "0099F8"))
                    
                }
                .padding(.horizontal, 35)
                .padding(.vertical, 10)
                .onTapGesture {
                    selectedToken.toggle()
                    selectedShopId = item.id
                }
            }
            Spacer()
        }
    }
}

