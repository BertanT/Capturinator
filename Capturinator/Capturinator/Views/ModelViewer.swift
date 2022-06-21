//
//  ModelViewer.swift
//  Object Capture Create
//
//  Created by Bertan on 24.06.2021.
//

import SwiftUI
import SceneKit

class NotFocusableSCNView: SCNView {
    override var acceptsFirstResponder: Bool { return false }
}

struct ModelViewer: NSViewRepresentable {
    private var modelURL: URL

    init(modelURL: URL) {
        self.modelURL = modelURL
    }

    func makeNSView(context: Context) -> SCNView {
        let scnView = NotFocusableSCNView()
        return scnView
    }

    func updateNSView(_ scnView: SCNView, context: Context) {
        let scene = try? SCNScene(url: modelURL)
        scene?.background.contents = NSColor.clear
        scnView.scene = scene
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = true
        scnView.backgroundColor = NSColor.clear
    }

}

struct ModelViewer_Previews: PreviewProvider {
    static var previews: some View {
        ModelViewer(modelURL: Bundle.main.url(forResource: "plane", withExtension: "usdz")!)
    }
}
