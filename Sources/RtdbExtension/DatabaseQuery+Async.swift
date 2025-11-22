//
//  DatabaseQuery+Async.swift
//  FirebaseX
//
//  Created by Long Vu on 22/11/25.
//

import FirebaseDatabase
import Foundation

private struct UncheckedCompletion: @unchecked Sendable {
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

public extension DatabaseQuery {
    func asAsyncThrowingStream(
        for eventType: DataEventType,
        streamType: DataStreamType = .continuous
    ) -> AsyncThrowingStream<DataSnapshot?, Error> {
        .init { continuation in
            switch streamType {
            case .continuous:
                let handle = observe(eventType) { snapshot in
                    continuation.yield(snapshot)
                } withCancel: { error in
                    continuation.finish(throwing: error)
                }

                let completion = UncheckedCompletion {
                    self.removeObserver(withHandle: handle)
                }

                continuation.onTermination = { termination in
                    debugPrint("Rtdb stream terminated \(termination)")
                    completion.block?()
                }

            case .once:
                fatalError("Not Handle Yet")

            case .latestValueFromServer:
                fatalError("Not Handle Yet")
            }
        }
    }
}
