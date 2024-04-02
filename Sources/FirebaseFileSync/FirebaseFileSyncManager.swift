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
            Self.fileManager.urls(
                for: .documentDirectory, in: .userDomainMask
            ).first!
        }

        let url = documentUrl.appendingPathComponent("firebase")

        return url
    }()

    private static let fileManager: FileManager = .default
    private let sharedContainer: URL
    private let sharedTargetPath: String = "persistence-sync-content"
    private var contentContainerURL: URL { sharedContainer.appendingPathComponent(sharedTargetPath) }

    public init(appGroup: String) {
        self.sharedContainer = Self.fileManager.containerURL(forSecurityApplicationGroupIdentifier: appGroup)!
    }

    public func reset() {}

    public func duplicateFirebaseFileToAppGroupContainer() throws {
        if Self.fileManager.fileExists(atPath: contentContainerURL.path) {
            try Self.fileManager.removeItem(at: contentContainerURL)
        }
        try Self.fileManager.copyItem(atPath: firebaseFileURL.path, toPath: contentContainerURL.path)
    }

    public func makeCopyOfFirebaseFileFromAppGroupContainer() throws {
        if !Self.fileManager.fileExists(atPath: contentContainerURL.path) {
            return
        }

        if Self.fileManager.fileExists(atPath: firebaseFileURL.path) {
            try Self.fileManager.removeItem(at: firebaseFileURL)
        }

        try Self.fileManager.copyItem(atPath: contentContainerURL.path, toPath: firebaseFileURL.path)
    }
}
