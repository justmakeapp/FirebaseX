//
//  DataSnapshot+Ext.swift
//  FirebaseX
//
//  Created by Long Vu on 31/1/26.
//

import FirebaseDatabase
import Foundation
import SwiftyJSON

public extension DataSnapshot {
    static func diff(previous: DataSnapshot?, current: DataSnapshot?) -> DataSnapshotDiffResult {
        let previousChildSnapshots = previous?.childSnapshots ?? []
        let currentChildSnapshots = current?.childSnapshots ?? []
        let currentIDs = Set(currentChildSnapshots.map(\.key))
        let previousIDs = Set(previousChildSnapshots.map(\.key))

        let added: [DataSnapshot] = currentChildSnapshots.filter { !previousIDs.contains($0.key) }

        let previousSnapshotMap = [String: DataSnapshot](
            previousChildSnapshots.map { ($0.key, $0) },
            uniquingKeysWith: { first, _ in first }
        )
        let currentSnapshotMap = [String: DataSnapshot](
            currentChildSnapshots.map { ($0.key, $0) },
            uniquingKeysWith: { first, _ in first }
        )
        let commonKeys = previousIDs.intersection(currentIDs)
        let modified = commonKeys.compactMap { key in
            let prevData = try? JSON(previousSnapshotMap[key]!.value as Any).rawData()
            let currentData = try? JSON(currentSnapshotMap[key]!.value as Any).rawData()

            if prevData != currentData {
                return currentSnapshotMap[key]!
            }
            return nil
        }

        let deleted: [DataSnapshot] = previousChildSnapshots.filter { !currentIDs.contains($0.key) }

        return DataSnapshotDiffResult(added: added, modified: modified, deleted: deleted)
    }
}

public struct DataSnapshotDiffResult {
    public let added: [DataSnapshot]
    public let modified: [DataSnapshot]
    public let deleted: [DataSnapshot]
}
