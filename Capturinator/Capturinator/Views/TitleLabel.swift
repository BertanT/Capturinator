//
//  TitleLabel.swift
//  Object Capture Create
//
//  Created by Bertan on 25.06.2021.
//

import SwiftUI

struct TitleLabel: View {
    let title: String
    let systemImage: String
    let gradient: Gradient

    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .accessibilityLabel(title)
            Text(title)
                .bold()
        }
        .roundedFont(.title2)
        .gradientBackground(gradient: gradient)
    }
}

struct TitleLabel_Previews: PreviewProvider {
    static var previews: some View {
        TitleLabel(title: "Hello, world!", systemImage: "face.smiling", gradient: .purpleGradient)
    }
}
