//
//  VisualEffectView.swift
//  Object Capture Create
//
//  Created by Bertan on 23.06.2021.
//

import SwiftUI

struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode

    func makeNSView(context: Context) -> NSVisualEffectView {
        let vfxView = NSVisualEffectView()

        vfxView.material = material
        vfxView.blendingMode = blendingMode
        vfxView.state = NSVisualEffectView.State.active

        return vfxView
    }

    func updateNSView(_ vfxView: NSVisualEffectView, context: Context) {
        vfxView.material = material
        vfxView.blendingMode = blendingMode
    }
}
