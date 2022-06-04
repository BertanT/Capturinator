//
//  GradientExtension.swift
//  Object Capture Create
//
//  Created by Bertan on 24.06.2021.
//

import SwiftUI

public extension Gradient {
    // Some hand dandy predefined gradients
    static var greenGradient = Gradient(colors: [NSColor.systemTeal, NSColor.systemGreen].map { Color($0) })
    static var indigoGradient = Gradient(colors: [NSColor.systemIndigo, NSColor.systemMint].map { Color($0) })
    static var yellowGradient = Gradient(colors: [NSColor.systemOrange, NSColor.systemPink].map { Color($0) })
    static var purpleGradient = Gradient(colors: [Color(NSColor.systemPurple), Color(NSColor.systemPink)])
    static var redGradient = Gradient(colors: [NSColor.systemRed, NSColor.systemPink].map { Color($0) })

    // Some fancy,
    // Computed property,
    // Some Fruit Company,
    // Gradient out here.

    // Those colors... Seem familiar somehow
    static func sixColorGradient(colorRange: ClosedRange<Int>? = nil) -> Gradient {
        let sixColors = [NSColor](arrayLiteral: .systemGreen, .systemYellow, .systemOrange, .systemRed, .systemPurple, .systemBlue).map { Color($0) }

        if let range = colorRange, sixColors.indices.contains(range.lowerBound), sixColors.indices.contains(range.upperBound) {
            return Gradient(colors: Array(sixColors[range]))

        } else {
            return Gradient(colors: sixColors)
        }
    }
}
