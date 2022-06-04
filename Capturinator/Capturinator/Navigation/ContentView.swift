//
//  ContentView.swift
//  Object Capture Create
//
//  Created by Bertan on 22.06.2021.
//

import SwiftUI
import SpriteKit
import SceneKit
import UserNotifications
import RealityKit

struct ContentView: View {
    @EnvironmentObject private var sharedData: SharedData
    @State private var photogrammetrySession: PhotogrammetrySession?
    @State private var showingCancelAlert = false
    
    var body: some View {
        
        NavigationView {
            Sidebar(photogrammetrySession: $photogrammetrySession)
                .frame(minWidth: 300, maxWidth: .infinity, maxHeight: .infinity)
                .environmentObject(sharedData)
                .background(
                    VisualEffectView(material: .windowBackground, blendingMode: .behindWindow)
                        .edgesIgnoringSafeArea(.all)
                )
            ZStack(alignment: .bottom) {
                VisualEffectView(material: .sidebar, blendingMode: .behindWindow)
                Group {
                    if let modelURL = sharedData.modelViewerModelURL {
                        ModelViewer(modelURL: modelURL)
                    } else {
                        Label(String(
                            localized: "NoModelToViewMessage",
                            comment: "Label: Viewed as a placeholder when there is no model in the model viewer"), systemImage: "arkit")
                        .font(.title2)
                    }
                }
                .frame(maxHeight: .infinity)
                ModelProgressView(cancelAction: {
                    showingCancelAlert.toggle()
                })
                .environmentObject(sharedData)
                .padding()
            }
        }
        .onAppear {
            
        }
        .onExitCommand {
            if photogrammetrySession?.isProcessing ?? false {
                showingCancelAlert.toggle()
            }
        }
        .onDisappear {
            photogrammetrySession?.cancel()
            if let modelViewerModelURL = sharedData.modelViewerModelURL {
                try? ModelFileManager().removeTempModel(modelURL: modelViewerModelURL)
            }
        }
        .alert(isPresented: $showingCancelAlert) {
            Alert(
                title:
                    Text("StopCreatingModelAlertTitle",
                         comment: "Title for the stop model creation confirmation dialog"),
                message:
                    Text("StopCreatingModelAlertBody",
                         comment: "Body for the stop model creation confirmation dialog"),
                primaryButton:
                        .cancel(),
                secondaryButton:
                        .destructive(Text("Stop",
                                          comment: "Stop model creation"), action: { photogrammetrySession?.cancel() })
            )
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: toggleSidebar) {
                    Label(
                        String(
                            localized: "ToggleSidebar",
                            comment: "Button: Toggles Sidebar"),
                        systemImage: "sidebar.left")
                }
            }
        }
    }
    
    func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
