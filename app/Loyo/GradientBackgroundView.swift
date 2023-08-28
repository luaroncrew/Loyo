//
//  GradientBackgroundView.swift
//  Loyo
//
//  Created by Nikita TEREKHOV on 13/05/2023.
//
import SwiftUI

struct GradientBackgroundView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.init(hex: "0099F8"), Color.init(hex: "FFFFFF")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .edgesIgnoringSafeArea(.all)
    }
}
