//
//  TouchBarFocusView.swift
//  Object Capture Create
//
//  Created by Bertan on 2.07.2021.
//

import SwiftUI

private class NSFocusView: NSView {
    override var acceptsFirstResponder: Bool { return true }
}

struct TouchBarFocusView: NSViewRepresentable {
    private let closeAlertWindowDelegate = CloseAlertWindowDelegate()
    func makeNSView(context: Context) -> some NSView {
        return NSFocusView()
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            if let window = nsView.window {
                // While we're at it, why not implement the window close alert :)
                window.delegate = closeAlertWindowDelegate
                if window.firstResponder as? NSWindow != nil {
                    window.makeFirstResponder(nsView)
                }
            }
        }
    }
}
