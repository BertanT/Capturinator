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
    @Binding private var shouldResetCamera: Bool

    init(modelURL: URL, shouldResetCamera: Binding<Bool>) {
        self.modelURL = modelURL
        self._shouldResetCamera = shouldResetCamera
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

        // Reset cam position if the reset variable is triggered
        if shouldResetCamera {
            SCNTransaction.begin()
            scnView.pointOfView?.position = SCNVector3(x: 5, y: 0, z: 5)
            scnView.pointOfView?.orientation = SCNVector4(x: 0, y: 1, z: 0, w: .pi/4)
            SCNTransaction.commit()
            shouldResetCamera = false

        }

    }
}
