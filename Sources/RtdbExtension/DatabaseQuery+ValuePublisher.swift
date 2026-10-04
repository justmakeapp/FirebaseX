// Created 15/02/2022

import Combine
@preconcurrency import CombineExt
import FirebaseDatabase
import Foundation

public extension DatabaseQuery {
    func publisher(
        for eventType: DataEventType,
        streamType: DataStreamType = .continuous
    ) -> AnyPublisher<DataSnapshot, Never> {
        switch streamType {
        case .continuous:
            return AnyPublisher<DataSnapshot, Never> { subscriber -> Cancellable in
                let handler = self.observe(eventType) { snapshot in
                    subscriber.send(snapshot)
                }
                return AnyCancellable {
                    self.removeObserver(withHandle: handler)
                }
            }

        case .once:
            return AnyPublisher<DataSnapshot, Never> { subscriber -> Cancellable in
                self.observeSingleEvent(of: eventType) { snapshot in
                    subscriber.send(snapshot)
                }
                return AnyCancellable {}
            }

        case .latestValueFromServer:
            return AnyPublisher<DataSnapshot, Never> { subscriber -> Cancellable in
                let subscriber = UncheckedSendableBox(subscriber)
                self.getData { _, snapshot in
                    let snapshot = snapshot ?? DataSnapshot()
                    subscriber.value.send(snapshot)
                }
                return AnyCancellable {}
            }
        }
    }

    func singleEventPublisher(for eventType: DataEventType) -> Future<DataSnapshot, Never> {
        return .init { promise in
            self.observeSingleEvent(of: eventType) { snapshot in
                promise(.success(snapshot))
            }
        }
    }

    func upToDateValueSinglePublisher() -> AnyPublisher<DataSnapshot?, Error> {
        return Deferred {
            Future { promise in
                let promise = UncheckedSendableBox(promise)
                self.getData { error, dataSnapshot in
                    if let error {
                        promise.value(.failure(error))
                        return
                    }

                    return promise.value(.success(dataSnapshot))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

public enum DataStreamType: String {
    case once
    case latestValueFromServer
    case continuous
}

/// Firebase invokes its callbacks on a single queue, so these captured values are not accessed concurrently.
struct UncheckedSendableBox<Value>: @unchecked Sendable {
    let value: Value

    init(_ value: Value) {
        self.value = value
    }
}
