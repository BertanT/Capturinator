//
//  ToggleWithSpacing.swift
//  Object Capture Create
//
//  Created by Bertan on 2.07.2021.
//

import SwiftUI

struct ToggleWithSpacing: View {
    let title: String
    @Binding var isOn: Bool
    
    init(_ title: String, isOn: Binding<Bool>) {
        self.title = title
        self._isOn = isOn
    }
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Toggle(title, isOn: $isOn)
                .labelsHidden()
                .toggleStyle(.switch)
        }
        .roundedFont(.headline)
    }
}
