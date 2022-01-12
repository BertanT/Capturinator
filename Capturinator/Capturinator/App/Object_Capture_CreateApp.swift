//
//  Object_Capture_CreateApp.swift
//  Object Capture Create
//
//  Created by Bertan on 22.06.2021.
//

import SwiftUI

@main
struct Object_Capture_CreateApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var sharedData = SharedData()
    @AppStorage("onboardingShown") private var onboardingShown = false
    @State private var showingOnboarding = false
    var supportsObjectCapture = CompatibilityChecker().checkObjectCaptureSupport()
    
    var body: some Scene {
        WindowGroup {
            if supportsObjectCapture {
                ContentView()
                    .frame(minWidth: 1280, maxWidth: .infinity, minHeight: 720, maxHeight: .infinity)
                    .environmentObject(sharedData)
                    .onAppear {
                        if !onboardingShown {
                            showingOnboarding = true
                            onboardingShown = true
                        }
                    }
                    .sheet(isPresented: $showingOnboarding) {
                        OnboardingView()

                    }
            }else {
                NotSupportedView()
                    .frame(minWidth: 1280, maxWidth: .infinity, minHeight: 720, maxHeight: .infinity)
            }
        }
        .commands {
            CommandGroup(replacing: .appInfo) {
                Button(String(localized: "AboutMenuCommandTtitle", comment: "Menu Command: Shows the about this app window")){
                    NSApplication.shared.orderFrontStandardAboutPanel(
                        options: [
                            NSApplication.AboutPanelOptionKey.credits: NSAttributedString(string: String(localized: "AboutWindowText", comment: "Short description of the app") + "\n" + String(localized: "MadeWithLove"), attributes: [ NSAttributedString.Key.font: NSFont.labelFont(ofSize: 12)]),
                            NSApplication.AboutPanelOptionKey(rawValue: "Copyright"): Bundle.main.object(forInfoDictionaryKey: "NSHumanReadableCopyright") ?? ""
                        ])
                    
                }
            }
            CommandGroup(replacing: .help) {
                Button(String(localized: "GettingStartedMenuCommandTittle", comment: "Menu Command: Shows the onboarding screen")) {
                    showingOnboarding.toggle()
                }
                .keyboardShortcut("?")
            }
            CommandGroup(after: .help) {
                Button(String(localized: "SupportMenuCommandTitle", comment: "Menu Command: Opens the Capturinator Support Website")) {
                    if let url = URL(string: "http://www.capturinator.bertan.codes/support") {
                        NSWorkspace.shared.open(url)
                    }
                }
            }
            SidebarCommands()
        }
    }
}
