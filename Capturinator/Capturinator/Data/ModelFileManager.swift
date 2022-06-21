//
//  TemporaryModels.swift
//  Object Capture Create
//
//  Created by Bertan on 10.07.2021.
//

import Foundation

class ModelFileManager {
    private func tempFolderURL(appropriateFor: URL?) -> URL {
        let tempFolderURL = try? FileManager.default.url(
            for: .itemReplacementDirectory, in: .userDomainMask,
            appropriateFor: appropriateFor, create: true)
        return tempFolderURL ?? URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
    }

    func generateTempModelURL(appropriateFor: URL? = nil) -> URL {
        let directoryURL = tempFolderURL(appropriateFor: appropriateFor)
        let tempFileURL = directoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("usdz")
        return tempFileURL
    }

    func copyTempModel(tempModelURL: URL, permanentURL: URL) throws {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: permanentURL.path) {
            try fileManager.removeItem(at: permanentURL)
        }
        try fileManager.copyItem(at: tempModelURL, to: permanentURL)
    }

    func removeTempModel(modelURL: URL) throws {
        try FileManager.default.removeItem(at: modelURL)
    }
}
