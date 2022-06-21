//
//  ModelProgressView.swift
//  Object Capture Create
//
//  Created by Bertan on 26.06.2021.
//

import SwiftUI

struct ModelProgressView: View {
    @EnvironmentObject private var sharedData: SharedData
    var cancelAction: () -> Void

    enum PresentationState { case hidden, initializing, bar, copying, finished }

    var body: some View {
        Group {
            switch sharedData.modelProgressViewState {
            case .hidden:
                EmptyView()
            case .initializing:
                HStack {
                    ProgressView()
                        .scaleEffect(0.6)
                    Text("Initializing", comment: "Starting model creation")
                        .roundedFont(.title3)
                    Spacer()
                }

            case .bar:
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 5.0) {
                        Text(
                            "CreatingModel \(Int(sharedData.modelProcessingProgress * 100))",
                            comment: "Text: Shows model creation progress in progress bar")
                        .bold()
                        .roundedFont(.body)

                        ProgressView(value: sharedData.modelProcessingProgress, total: 1)
                    }
                    Button(action: cancelAction) {
                        Image(systemName: "xmark.circle.fill")
                    }
                    .help(String(localized: "StopCreating", comment: "Button[Progress Bar]: Stops model creation"))
                    .buttonStyle(BorderlessButtonStyle())
                }
            case .copying:
                HStack {
                    ProgressView()
                        .scaleEffect(0.6)
                    Text("SavingModel", comment: "Text: Shown in progress bar while saving a finished model")
                        .roundedFont(.title3)
                    Spacer()
                }
            case .finished:
                HStack {
                    Label {
                        Text("ExportComplete \(sharedData.showInFinderURL?.lastPathComponent ?? "")",
                             comment: "Text: Shown in progress bar after a model has been successfully exported")
                    }icon: {
                        Image(systemName: "checkmark.circle")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.green)
                            .imageScale(.large)
                            .font(.title2)
                    }
                    .roundedFont(.title3)
                    Spacer()
                    Button(String(localized: "ShowInFinder", comment: "Button: Shows the exported model in Finder")) {
                        NSWorkspace.shared.selectFile(sharedData.showInFinderURL?.path, inFileViewerRootedAtPath: "")
                    }
                    Button {
                        withAnimation {
                            sharedData.modelProgressViewState = .hidden
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                    .help(
                        String(
                            localized: "Dismiss",
                            comment: "Button: Hides the progress bar before it automatically hides after successful export"))
                    .buttonStyle(BorderlessButtonStyle())
                }

            }
        }
        .zIndex(1)
        .transition(.move(edge: .bottom))
        .frame(maxWidth: .infinity, maxHeight: 25)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .shadow(radius: 15)
                .foregroundStyle(.regularMaterial)
        )
        .onChange(of: sharedData.modelProgressViewState) { newValue in
            if newValue == .finished {
                DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
                    withAnimation {
                        sharedData.modelProgressViewState = .hidden
                    }
                }
            }
        }
    }
}
