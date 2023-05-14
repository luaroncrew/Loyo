import SwiftUI
import EFQRCode

// TODO: refactor
extension UUID: Identifiable {
    public var id: UUID { self }
}

@available(iOS 16.0, *)
struct ContentView: View {
    @State var selectedToken: Bool = false
    @State var selectedShopId: UUID?

    @StateObject var blockchainConnector = BlockchainConnector.shared

    var body: some View {
        TabView {
            ZStack {
                GradientBackgroundView()
                BonusPointsView()
            }
            .tabItem {
                 Image(systemName: "house")
                 Text("Receive")
             }
            .onAppear {
                Task {
                    try await blockchainConnector.fetchShops()
                }
            }

            SpendBonusPointsView(
                selectedToken: $selectedToken,
                selectedShopId: $selectedShopId,
                shops: blockchainConnector.shops
            )
            .background(Color.white)
            .cornerRadius(15)
            .tabItem {
                Image(systemName: "dollarsign.circle")
                Text("Spend")
            }
            .sheet(item: $selectedShopId) { _ in
                   SelectedTokenView(
                       selectedShopId: $selectedShopId,
                       shops: blockchainConnector.shops
                   )
               }
        }
        .toolbarColorScheme(.dark, for: .tabBar)

    }
}
