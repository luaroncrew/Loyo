import SwiftUI
import EFQRCode

// TODO: refactor
extension UUID: Identifiable {
    public var id: UUID { self }
}

@available(iOS 16.0, *)
struct ContentView: View {
    @State var tokenSelected: Bool = false
    @State var selectedShopId: UUID?

    @StateObject var blockchainConnector = BlockchainConnector.shared

    var body: some View {
        TabView {
            ZStack {
                GradientBackgroundView()
                GetBonusPointsView()
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
                tokenSelected: tokenSelected,
                selectedShopId: selectedShopId
            )
            .background(Color.white)
            .cornerRadius(15)
            .tabItem {
                Image(systemName: "dollarsign.circle")
                Text("Spend")
            }
        }
        .toolbarColorScheme(.dark, for: .tabBar)
    }
}
