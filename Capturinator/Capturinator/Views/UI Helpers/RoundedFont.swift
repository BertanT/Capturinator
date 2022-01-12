//
//  RoundedFont.swift
//  Object Capture Create
//
//  Created by Bertan on 24.06.2021.
//

import SwiftUI

extension View {
    func roundedFont(_ style: Font.TextStyle) -> some View {
        self
            .font(.system(style, design: .rounded))
    }
}
