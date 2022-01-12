//
//  AppDelegate.swift
//  Object Capture Create
//
//  Created by Bertan on 26.06.2021.
//

import SwiftUI
import AppKit
import UserNotifications

class AppDelegate: NSObject, NSApplicationDelegate {
    @AppStorage("userSuppressedQuitAlert") private var userSuppressedQuitAlert = false
    private var shouldAskBeforeQuitting = true
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge]) { success, error in
            if success {
                print("User granted notifications access :)")
            }else if let e = error {
                print(e.localizedDescription)
            }
        }
    }
    
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        shouldAskBeforeQuitting = false
        return true
    }
    
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        if shouldAskBeforeQuitting, !userSuppressedQuitAlert {
            let alert = NSAlert()
            alert.alertStyle = .warning
            alert.messageText = String(localized: "QuitAppAlertTitle", comment: "Title of the app termination confirmation dialog")
            alert.informativeText = String(localized: "QuitAppAlertBody", comment: "Body of the app termination confirmation dialog")
            alert.addButton(withTitle: String(localized: "Quit", comment: "Button: Quits app"))
            alert.addButton(withTitle: String(localized: "Cancel", comment: "General purpose cancel button"))
            alert.showsSuppressionButton = true

            let response = alert.runModal()
            
            if let suppressionResponse = alert.suppressionButton?.state {
                if suppressionResponse == NSControl.StateValue.on  {
                    userSuppressedQuitAlert = true
                }
            }
            
            if response == .alertSecondButtonReturn {
                return .terminateCancel
            }
        }
        return .terminateNow
    }
}
