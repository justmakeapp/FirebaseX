//
//  FirebaseFileSyncManager.swift
//
//
//  Created by Long Vu on 2/4/24.
//

import Foundation

public struct FirebaseFileSyncManager {
    public let firebaseFileURL: URL = {
        let documentUrl: URL = if #available(iOS 16.0, macOS 13.0, *) {
            URL.documentsDirectory
        } else {
            FileManager.default.urls(
                for: .documentDirectory, in: .userDomainMask
            ).first!
        }

        let url = documentUrl.appendingPathComponent("firebase")

        return url
    }()

    private let sharedContainer: URL
    private let sharedTargetPath: String = "persistence-sync-content"
    private var contentContainerURL: URL { sharedContainer.appendingPathComponent(sharedTargetPath) }

    public init(appGroup: String) {
        self.sharedContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup)!
    }

    public func reset() {}

    public func duplicateFirebaseFileToAppGroupContainer() throws {
        if FileManager.default.fileExists(atPath: contentContainerURL.path) {
            try FileManager.default.removeItem(at: contentContainerURL)
        }
        try FileManager.default.copyItem(atPath: firebaseFileURL.path, toPath: contentContainerURL.path)
    }

    public func makeCopyOfFirebaseFileFromAppGroupContainer() throws {
        if !FileManager.default.fileExists(atPath: contentContainerURL.path) {
            return
        }

        if FileManager.default.fileExists(atPath: firebaseFileURL.path) {
            try FileManager.default.removeItem(at: firebaseFileURL)
        }

        try FileManager.default.copyItem(atPath: contentContainerURL.path, toPath: firebaseFileURL.path)
    }
}
