//
//  CompatibilityChecker.swift
//  Capturinator
//
//  Created by Bertan on 11.01.2022.
//

import Metal

class CompatibilityChecker {
    private func supportsObjectReconstruction() -> Bool {
        for device in MTLCopyAllDevices() where
        !device.isLowPower &&
        device.areBarycentricCoordsSupported &&
        device.recommendedMaxWorkingSetSize >= UInt64(4e9) {
            return true
        }
        return false
    }

    private func supportsRayTracing() -> Bool {
        for device in MTLCopyAllDevices() where device.supportsRaytracing {
            return true
        }
        return false
    }

    func checkObjectCaptureSupport() -> Bool {
        return supportsObjectReconstruction() && supportsRayTracing()
    }
}
