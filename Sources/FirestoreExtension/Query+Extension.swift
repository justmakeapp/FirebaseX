//
//  Query+Extension.swift
//
//
//  Created by Long Vu on 11/04/2023.
//

import FirebaseFirestore

struct UncheckedCompletion: @unchecked Sendable {
    typealias Block = () -> Void

    let block: Block?

    init(_ block: Block?) {
        if let block {
            self.block = {
                block()
            }
        } else {
            self.block = nil
        }
    }
}

public extension Query {
    func asAsyncStream(
        includeMetadataChanges: Bool = false
    ) -> AsyncStream<QuerySnapshot?> {
        .init { continuation in
            let listener = addSnapshotListener(includeMetadataChanges: includeMetadataChanges) { snapshot, error in
                if let error {
                    if (error as NSError).code == FirestoreErrorCode.permissionDenied.rawValue {
                        debugPrint("[FirebaseX] \(#function): Permission denied. Maybe user did sign out.")
                    } else {
                        debugPrint("[FirebaseX] \(#function) Query stream error: \(error)")
                    }
                    continuation.finish()
                } else {
                    continuation.yield(snapshot)
                }
            }

            let completion = UncheckedCompletion {
                listener.remove()
            }

            continuation.onTermination = { termination in
                debugPrint("[FirebaseX] \(#function) Query stream terminated \(termination)")
                completion.block?()
            }
        }
    }

    func asAsyncThrowingStream(
        includeMetadataChanges: Bool = false
    ) -> AsyncThrowingStream<QuerySnapshot?, Error> {
        .init { continuation in
            let listener = addSnapshotListener(includeMetadataChanges: includeMetadataChanges) { snapshot, error in
                if let error {
                    if (error as NSError).code == FirestoreErrorCode.permissionDenied.rawValue {
                        debugPrint("[FirebaseX] \(#function): Permission denied. Maybe user did sign out.")
                        continuation.finish()
                    } else {
                        debugPrint("[FirebaseX] \(#function) Query stream error: \(error)")
                        continuation.finish(throwing: error)
                    }
                } else {
                    continuation.yield(snapshot)
                }
            }

            let completion = UncheckedCompletion {
                listener.remove()
            }

            continuation.onTermination = { termination in
                debugPrint("[FirebaseX] \(#function) Query stream terminated \(termination)")
                completion.block?()
            }
        }
    }
}
