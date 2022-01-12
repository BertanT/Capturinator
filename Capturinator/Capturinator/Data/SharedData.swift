//
//  SharedData.swift
//  Object Capture Create
//
//  Created by Bertan on 27.06.2021.
//

import Foundation
import Metal
import Combine

final class SharedData: ObservableObject {
    @Published var modelViewerModelURL: URL?
    @Published var modelProgressViewState: ModelProgressView.PresentationState = .hidden
    @Published var modelProcessingProgress: CGFloat = 0.0
    @Published var showInFinderURL: URL?
}
