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
            gradient: Gradient(colors: [Color.init(hex: "99EDCC"), Color.init(hex: "0099F8")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .edgesIgnoringSafeArea(.all)
    }
}
