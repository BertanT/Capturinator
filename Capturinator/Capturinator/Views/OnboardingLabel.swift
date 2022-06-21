//
//  OnboardingLabel.swift
//  OnboardingLabel
//
//  Created by Bertan on 14.08.2021.
//

import SwiftUI

struct OnboardingLabel: View {
    let title: String
    let description: String
    let systemImage: String

    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .font(.largeTitle)
                .foregroundColor(.accentColor)
                .frame(width: 40)
            VStack(alignment: .leading) {
                Text((try? AttributedString(markdown: title)) ?? "MD Formatting Error!")
                    .roundedFont(.headline)
                Text((try? AttributedString(markdown: description)) ?? "MD Formatting Error!")
                    .roundedFont(.body)
            }
        }
    }
}

struct OnboardingLabel_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading) {
            OnboardingLabel(title: "Hello, World!", description: "Lorem ipsum dolor sit amet.", systemImage: "camera.fill")
        }
    }
}
