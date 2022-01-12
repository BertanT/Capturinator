//
//  Sidebar.swift
//  Object Capture Create
//
//  Created by Bertan on 23.06.2021.
//

import SwiftUI
import Combine
import RealityKit
import UserNotifications

struct Sidebar: View {
    typealias PSConfig = PhotogrammetrySession.Configuration
    typealias PSRequestDetail = PhotogrammetrySession.Request.Detail
    
    @State private var processingErrorOccured = false
    
    @EnvironmentObject private var sharedData: SharedData
    @Binding var photogrammetrySession: PhotogrammetrySession?
    
    @State private var showingAlert = false
    
    @State private var usingSequentialSamples = false
    @State private var objectMasking = true
    @State private var highFeatureSensivity = false
    
    @State private var alertText = "" {
        didSet { showingAlert.toggle() }
    }
    
    @State private var inputFolderURL: URL?
    @State var psConfig = PhotogrammetrySession.Configuration()
    @State private var requestDetail: PSRequestDetail = .medium
    @State private var psProcessTask: Task<(), Never>?
    
    @FocusState private var isFocused: Bool
    
    enum TouchBarState { case main, settings, quality }
    @State private var touchBarState: TouchBarState = .main
    
    var body: some View {
        VStack {
            // Tocuh Bar! This view is not visible
            TouchBarFocusView()
                .frame(width: 0, height: 0)
                .touchBar(
                    TouchBar(id: UUID().uuidString) {
                    Group {
                        switch touchBarState {
                        case .main:
                            Button(action: openFolder) {
                                Label(String(localized: "OpenFolder", comment: "Button[TouchBar]: Opens image folder"), systemImage: "folder.fill")
                            }
                            Button(action: {
                                touchBarState = .settings
                            }) {
                                Label(String(localized: "Settings", comment: "Button[TouchBar]: Shows Model Settings Strip"), systemImage: "slider.horizontal.3")
                            }
                            Button(action: {
                                touchBarState = .quality
                            }) {
                                Label(NSLocalizedString("Quality", comment: "Button[TouchBar]: Shows Model Quality Picker Strip"), systemImage: "dial.min.fill")
                            }
                            Spacer()
                            Group {
                                Button(action: createPreview) {
                                    Label(String(localized: "Preview", comment: "Button[TouchBar]: Creates a preview model"), systemImage: "paintbrush.fill")
                                }
                                Button(action: { exportModel() }) {
                                    Label(String(localized: "ExportModel", comment: "Button: Creates and exports model"), systemImage: "arkit")
                                }
                                .buttonStyle(.borderedProminent)
                            }
                            .disabled(inputFolderURL == nil || photogrammetrySession?.isProcessing ?? false)
                        case .settings:
                            Button(action: {
                                withAnimation {
                                    touchBarState = .main
                                }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title)
                            }
                            .buttonStyle(.borderless)
                            ToggleWithSpacing(String(localized: "SequentialSamples", comment: "Toggle: Sets Sequential samples option"), isOn: $usingSequentialSamples)
                            ToggleWithSpacing(String(localized: "ObjectMasking", comment: "Toggle: Sets Object masking option"), isOn: $objectMasking)
                            ToggleWithSpacing(String(localized: "HighFeatureSensitivityShortened", comment: "Toggle[TouchBar]: Sets high feature sensitivity option"), isOn: $highFeatureSensivity)
                        case .quality:
                            Button(action: {
                                withAnimation {
                                    touchBarState = .main
                                }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title)
                            }
                            .buttonStyle(.borderless)


                            Button(action: {
                                requestDetail = .reduced
                            }) {
                                CheckableLabel(text: String(localized: "Reduced", comment: "The lowest model quality"), systemImage: "square.grid.2x2", checked: requestDetail == .reduced)
                            }

                            Button(action: {
                                requestDetail = .medium
                            }) {
                                CheckableLabel(text: String(localized: "Medium", comment: "Medium model quality"), systemImage: "square.grid.2x2.fill", checked: requestDetail == .medium)
                            }

                            Button(action: {
                                requestDetail = .full
                            }) {
                                CheckableLabel(text: String(localized: "Full", comment: "Full model quality"), systemImage: "square.grid.3x2", checked: requestDetail == .full)
                            }

                            Button(action: {
                                requestDetail = .raw
                            }) {
                                CheckableLabel(text: String(localized: "RAW", comment: "RAW model quality"), systemImage: "square.grid.3x2.fill", checked: requestDetail == .raw)
                            }
                        }
                    }
                    .disabled(photogrammetrySession?.isProcessing ?? false)
                }
                )
            Text("Welcome", comment: "Welcome text at the top of the sidebar")
                .bold()
                .roundedFont(.largeTitle)
                .gradientBackground(gradient: .indigoGradient)
            Text("AppInfo", comment: "Short app info under the welcome text in the sidebar")
                .roundedFont(.body)
                .multilineTextAlignment(.center)
                .padding([.horizontal, .bottom])
                .offset(y: 10)
            
            VStack(alignment: .leading) {
                Divider()
                    .padding(.bottom, 5)
                Group {
                    TitleLabel(title: String(localized: "ImageFolder", comment: "Image folder title in the sidebar"), systemImage: "folder.fill", gradient: .purpleGradient)
                    HStack {
                        Group {
                            if let url = inputFolderURL {
                                Text(url.lastPathComponent)
                                Spacer()
                            }else {
                                Text("NotSelected", comment: "Image folder name placeholder when not selected")
                            }
                        }
                        .roundedFont(.headline)
                        Spacer()
                        Button(inputFolderURL == nil ? String(localized: "Open", comment: "Button: Opens image folder") : String(localized: "Change", comment: "Chnages the selected image folder")) {
                            openFolder()
                        }
                        .roundedFont(.body)
                    }
                    .helpPopover(title: String(localized: "ImageFolderHelpTitle", comment: "Help popover title for image folder"), description: String(localized: "ImageFolderHelpBody", comment: "Help popover body for image folder"))
                    .padding(0)
                }
                .disabled(photogrammetrySession?.isProcessing ?? false)
                
                Divider()
                    .padding(.vertical, 5)
                
                Group {
                    TitleLabel(title: String(localized: "ModelSettings", comment: "Model Settings title in the sidebar"), systemImage: "slider.horizontal.3", gradient: .yellowGradient)
                    
                    ToggleWithSpacing(String(localized: "SequentialSamples"), isOn: $usingSequentialSamples)
                        .onChange(of: usingSequentialSamples) { newValue in
                            psConfig.sampleOrdering = newValue ? .sequential : .unordered
                        }
                        .helpPopover(title: String(localized: "SequentialSamplesHelpTitle", comment: "Help popover title for sequential samples"), description: String(localized: "SequentialSamplesHelpBody", comment: "Help popover body for sequential samples"))
                    
                    ToggleWithSpacing(String(localized: "ObjectMasking"), isOn: $objectMasking)
                        .onChange(of: objectMasking) { newValue in
                            psConfig.isObjectMaskingEnabled = newValue
                        }
                        .helpPopover(title: String(localized: "ObjectMaskingHelpTitle", comment: "Help popover title for object masking"), description: String(localized: "ObjectMaskingHelpBody", comment: "Help popover body for object masking"))
                    
                    ToggleWithSpacing(String(localized: "HighFeatureSensitivity"), isOn: $highFeatureSensivity)
                        .onChange(of: highFeatureSensivity) { newValue in
                            psConfig.featureSensitivity = newValue ? .high : .normal
                        }
                        .helpPopover(title: String(localized: "HighFeatureSensitivityHelpTitle", comment: "Help popover title for high feature sensitivity"), description: String(localized: "HighFeatureSensitivityHelpBody", comment: "Help popover body for high feature sensitivity"))
                    
                    Picker(String(localized: "ModelQuality", comment: "Picker: Sets the model quality"), selection: $requestDetail) {
                        Text("RAW").tag(PSRequestDetail.raw)
                        Text("Full").tag(PSRequestDetail.full)
                        Text("Medium").tag(PSRequestDetail.medium)
                        Text("Reduced").tag(PSRequestDetail.reduced)
                    
                    }
                    .roundedFont(.headline)
                    .helpPopover(title: String(localized: "ModelQualityHelpTitle", comment: "Help popover title for model quality"), description: String(localized: "ModelQualityHelpBody", comment: "Help popover title for model quality"))
                }
                .disabled(photogrammetrySession?.isProcessing ?? false)
                
                Spacer()
                
                Divider()
                    .padding(.vertical, 5)
                Group {
                    TitleLabel(title: String(localized: "Rendering", comment: "Rendering title in the sidebar"), systemImage: "paintbrush.fill", gradient: .greenGradient)
                    HStack {
                        Spacer()
                        Button(sharedData.modelViewerModelURL == nil ? String(localized: "CreatePreview", comment: "Creates a preview model") : String(localized: "RefinePreview", comment: "Refines a preview model")) {
                            createPreview()
                        }
                        .controlSize(.large)
                        Spacer()
                        Button("ExportModel") {
                            exportModel()
                        }
                        .controlSize(.large)
                        .buttonStyle(.borderedProminent)
                        Spacer()
                    }
                    .roundedFont(.body)
                }
                .disabled(inputFolderURL == nil || photogrammetrySession?.isProcessing ?? false)
            }
            .padding([.horizontal, .bottom])
        }
        .alert(isPresented: $showingAlert) {
            return Alert(title: Text(String(localized: "ErrorAlertTitle", comment: "Title for generic error alert")), message: Text(alertText), dismissButton: nil)
        }
    }
    
    private func openFolder() {
        let openPanel = NSOpenPanel()
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        if openPanel.runModal() == .OK {
            self.inputFolderURL = openPanel.url
            print("Source folder selected: \(openPanel.url!)")
        }
    }
    
    private func chooseSaveDestination() -> URL? {
        // Clear out the old url
        let savePanel = NSSavePanel()
        savePanel.title = String(localized: "SavePanelTitle", comment: "Title for the save panel shown before exporting model")
        savePanel.allowsOtherFileTypes = false
        savePanel.allowedContentTypes = [.usdz]
        savePanel.nameFieldStringValue = String(localized: "DefaultExportFilename", comment: "Default filename while saving the model")
        if savePanel .runModal() == .OK {
            return savePanel.url
        }
        return nil
    }
    
    private func createModel(permenantSaveURL: URL? = nil) {
        processingErrorOccured = false

        guard let inputURL = inputFolderURL else {
            print("inputFolderURL is nil! Aborting...")
            processingErrorOccured = true
            alertText = String(localized: "NoSourceFolderErrorAlertBody", comment: "Alert body for no source folder found error")
            return
        }

        do {
            photogrammetrySession = try PhotogrammetrySession(input: inputURL, configuration: psConfig)
        }catch {
            print("Could not create photogrammetry session, aborting...")
            processingErrorOccured = true
            alertText = String(localized: "PSCreationErrorAlertBody", comment: "Alert body for photogrammetry session creation error")
            return
        }
        
        let temporarySaveURL = ModelFileManager().generateTempModelURL(apropiateFor: permenantSaveURL)
        let request = PhotogrammetrySession.Request.modelFile(url: temporarySaveURL, detail: permenantSaveURL == nil ? .preview : requestDetail)
        
        
        Task(priority: .userInitiated) {
            do {
                for try await output in photogrammetrySession!.outputs {
                    switch output {
                    case .inputComplete:
                        print("Successfully initiallized images, beginning processing...")
                    case .requestError(_, _):
                        print("Request error!")
                        processingErrorOccured = true
                        alertText = String(localized: "ModelCreationErrorAlertBody", comment: "Alert body for model creation error")
                    case .requestComplete(_, _):
                        print("Completed request!")
                    case .requestProgress(_, fractionComplete: let fractionComplete):
                        print("Current request is \(Int(fractionComplete*100))% complete")
                        sharedData.modelProgressViewState = .bar
                        sharedData.modelProcessingProgress = fractionComplete
                    case .processingComplete:
                        print("Done processing!")
                        handleCreationCompletion(temporaryLocation: temporarySaveURL, permenantSaveURL: permenantSaveURL)
                    case .processingCancelled:
                        print("Processing is cancelled")
                        withAnimation {
                            sharedData.modelProgressViewState = .hidden
                        }
                    case .invalidSample(id: let id, reason: let reason):
                        print("Sample with the id \(id) is invalid. Reason: \(reason)")
                    case .skippedSample(id: let id):
                        print("Skipped a sample image with id: \(id)")
                    case .automaticDownsampling:
                        print("Enabled auto downsampling because of limited system resources!")
                    @unknown default:
                        print("Received unknown session output: \(output)")
                    }
                }
            }catch {
                print("Unexpected fatal session error. Aborting... ERROR=\(error)")
                processingErrorOccured = true
                alertText = String(localized: "UnexpectedFatalSessionErrorAlertBody", comment: "Alert body for unexpected fatal session error")
            }
        }

        do {
            withAnimation {
                sharedData.modelProgressViewState = .initializing
            }

            try photogrammetrySession!.process(requests: [request])
        }catch {
            print("Cannot process requests. ERROR=\(error)")
            processingErrorOccured = true
            alertText = String(localized: "UnexpectedModelCreationErrorAlertBody", comment: "Alert body for unexpected model creation error")
            withAnimation {
                sharedData.modelProgressViewState = .hidden
            }
        }

    }
    
    private func createPreview() {
        createModel()
    }
    
    private func exportModel() {
        if let destinationURL = chooseSaveDestination() {
            createModel(permenantSaveURL: destinationURL)
        }
    }
    
    private func handleCreationCompletion(temporaryLocation: URL, permenantSaveURL: URL? = nil) {
        if processingErrorOccured {
            withAnimation {
                sharedData.modelProgressViewState = .hidden
            }
            sendCreationConclusionNotification(success: false, exportedModelFilename: permenantSaveURL?.lastPathComponent)
            return
        }
        
        let modelFileManager = ModelFileManager()
        
        let oldModelURL = sharedData.modelViewerModelURL
        
        withAnimation {
            sharedData.modelViewerModelURL = temporaryLocation
        }
        
        if let oldURL = oldModelURL {
            try? modelFileManager.removeTempModel(modelURL: oldURL)
        }
        
        if let saveURL = permenantSaveURL {
            sharedData.modelProgressViewState = .copying
            do {
                try modelFileManager.copyTempModel(tempModelURL: temporaryLocation, permanentURL: saveURL)
                sharedData.showInFinderURL = saveURL
                sharedData.modelProgressViewState = .finished
            }catch {
                print("Cannot save model to destination URL")
                alertText = String(localized: "ModelSaveErrorAlertBody", comment: "Alert body for model save")
            }
        }else {
            withAnimation {
                sharedData.modelProgressViewState = .hidden
            }
        }
        sendCreationConclusionNotification(success: true, exportedModelFilename: permenantSaveURL?.lastPathComponent)
    }
    
    private func sendCreationConclusionNotification(success: Bool, exportedModelFilename: String?) {
        let content = UNMutableNotificationContent()
        
        if let filename = exportedModelFilename {
            if success {
                content.title    = String(localized: "ModelExportSucessNotificationTitle", comment: "Notification title for model export success")
                content.subtitle = String(format: String(localized: "ModelExportSucessNotificationBody %@", comment: "Notification body for model export success"), filename)
            }else {
                content.title    = String(localized: "ModelExportFailureNotificationTitle", comment: "Notification title for model export failure")
                content.subtitle = String(format: String(localized: "ModelExportFailureNotificationBody %@", comment: "Notification body for model export failure"), filename)
            }
        }else if let inputFolderName = inputFolderURL?.lastPathComponent {
            if success {
                content.title    = String(localized: "PreviewCreationSuccessNotificationTitle", comment: "Notification title for preview creation success")
                content.subtitle = String(format: String(localized: "PreviewCreationSuccessNotificationBody %@", comment: "Notification body for preview creation success"), inputFolderName)
            }else {
                content.title    = String(localized: "PreviewCreationFailureNotificationTitle", comment: "Notification title for preview creation failure")
                content.subtitle = String(format: String(localized: "PreviewCreationFailureNotificationBody %@", comment: "Notification body for preview creation failure"), inputFolderName)
            }
        }
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
}
