//
//  CheckableLabel.swift
//  CheckableLabel
//
//  Created by Bertan on 22.07.2021.
//

import SwiftUI

struct CheckableLabel: View {
    let text: String
    let systemImage: String
    let checked: Bool
    var body: some View {
        HStack {
            Label(text, systemImage: systemImage)
            if checked {
                Image(systemName: "checkmark")
            } else {
                Image(systemName: "checkmark")
                    .hidden()
            }
        }
    }
}

struct CheckableLabelPreviews: PreviewProvider {
    static var previews: some View {
        CheckableLabel(text: "Hello World", systemImage: "face.smiling", checked: true)
            .font(.largeTitle)
    }
}
