//
//  LoyoApp.swift
//  Loyo
//
//  Created by Kirill on 5/2/23.
//

import SwiftUI

@available(iOS 16.0, *)
@main
struct LoyoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear(perform: {
                    BlockchainConnector.shared.initializeAccount()
                })
        }
    }
}

