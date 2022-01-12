//
//  GradientBackground.swift
//  Object Capture Create
//
//  Created by Bertan on 25.06.2021.
//

import SwiftUI

extension View {
    func gradientBackground(gradient: Gradient, startPoint: UnitPoint = .topLeading, endPoint: UnitPoint = .bottomTrailing) -> some View {
        self
            .overlay(LinearGradient(gradient: gradient, startPoint: startPoint, endPoint: endPoint))
            .mask(self)
    }
}
