//
//  Query+Extension.swift
//
//
//  Created by Long Vu on 11/04/2023.
//

import Combine
import CombineExt
import FirebaseFirestore

public extension Query {
//    func publisher() -> AnyPublisher<QuerySnapshot?, Error> {
//        return AnyPublisher.init { subscriber in
//            let listener = self.addSnapshotListener { snapshot, error in
//                if let error {
//                    debugPrint(error.localizedDescription)
//                    subscriber.send(completion: .failure(error))
//                    return
//                }
//
//                subscriber.send(snapshot)
//            }
//
//            return AnyCancellable {
//                listener.remove()
//            }
//        }
//    }
}
