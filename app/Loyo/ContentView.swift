//
//  ContentView.swift
//  Loyo
//
//  Created by Kirill on 5/2/23.
//

import SwiftUI
import EFQRCode



struct ContentView: View {
    @State var selectedToken: Bool = false
    @State var selectedTokenName: String = ""
    @State var chosenShopBalance: Double = 0
    @State var qrImage: UIImage? = nil

    @StateObject var blockchainConnector = BlockchainConnector.shared

    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                GradientBackgroundView()

                VStack {
                    BonusPointsView()
                        .frame(height: geometry.size.height * 0.8)
                    Spacer()
                }

                ScrollView {
                    VStack {
                        Spacer()
                            .frame(height: geometry.size.height * 0.8)
                        SpendBonusPointsView(chosenShopBalance: $chosenShopBalance, selectedTokenName: $selectedTokenName, selectedToken: $selectedToken)
                            .background(Color.white)
                            .cornerRadius(15)
                    }
                    .background(Color.clear)
                    .ignoresSafeArea()
                }
                .sheet(isPresented: $selectedToken) {
                    SelectedTokenView(tokenName: $selectedTokenName, balance: $chosenShopBalance)
                }
            }
        }
    }

}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}
