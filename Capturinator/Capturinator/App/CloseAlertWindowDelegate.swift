//
//  CloseAlertWindowDelegate.swift
//  Object Capture Create
//
//  Created by Bertan on 28.06.2021.
//

import AppKit
import SwiftUI

class CloseAlertWindowDelegate: NSObject, NSWindowDelegate {
    @AppStorage("userSuppressedWindowCloseAlert") private var userSuppressedWindowCloseAlert = false
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        if !userSuppressedWindowCloseAlert {
            let alert = NSAlert()
            alert.alertStyle = .warning
            alert.messageText = String(localized: "CloseWindowAlertTitle", comment: "Title of the window closing confirmation dialog")
            alert.informativeText = String(localized: "CloseWindowAlertBody", comment: "Body of the window closing confirmation dialog")
            alert.addButton(withTitle: NSLocalizedString("Close", comment: "Button: Closes window"))
            alert.addButton(withTitle: String(localized: "Cancel"))
            alert.showsSuppressionButton = true
            
            let response = alert.runModal()
            
            if let suppressionResponse = alert.suppressionButton?.state {
                if suppressionResponse == NSControl.StateValue.on  {
                    userSuppressedWindowCloseAlert = true
                }
            }
            
            if response == .alertSecondButtonReturn {
                return false
            }
        }
        return true
    }
}
