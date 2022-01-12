//
//  HelpPopover.swift
//  Object Capture Create
//
//  Created by Bertan on 25.06.2021.
//

import SwiftUI

struct HelpPopover: View {
    @State private var presented = false
    let title: String
    let description: String
    var body: some View {
        Button(action: { presented.toggle() }) {
            Image(systemName: "questionmark.circle")
                .accessibilityLabel(title)
                .font(.title3)
        }
        .buttonStyle(BorderlessButtonStyle())
        .popover(isPresented: $presented) {
            VStack(alignment: .leading) {
                Text(title)
                    .roundedFont(.headline)
                Text(description)
            }
            .frame(width: 300)
            .frame(maxHeight: .infinity)
            .padding(10)
        }
    }
}

extension View {
    func helpPopover(title: String, description: String) -> some View {
        HStack {
            HelpPopover(title: title, description: description)
                .padding(.leading, 3)
            self
        }
    }
}

struct HelpPopover_Previews: PreviewProvider {
    static var previews: some View {
        HelpPopover(title: "Hello, world!", description: "This is the SwiftUI preview for the help popover veiw I've created")
    }
}
