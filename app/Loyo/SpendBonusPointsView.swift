//
//  SpendBonusPointsView.swift
//  Loyo
//
//  Created by Nikita TEREKHOV on 13/05/2023.
//

import SwiftUI

struct SpendBonusPointsView: View {
    @Binding var chosenShopBalance: Double
    @Binding var selectedTokenName: String
    @Binding var selectedToken: Bool

    
    var body: some View {
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
        }
    }
}

