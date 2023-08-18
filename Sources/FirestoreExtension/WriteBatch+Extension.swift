//
//  WriteBatch+Extension.swift
//
//
//  Created by longvu on 08/09/2022.
//

#if canImport(FirebaseFirestore)
    import FirebaseFirestore

    public extension WriteBatch {
        @discardableResult
        func setEncodableData(
            _ value: (some Encodable)?,
            forDocument document: DocumentReference,
            with encoder: JSONEncoder = .init()
        ) throws -> WriteBatch {
            let encodedData = try encoder.encode(value)
            let jsonObject = try JSONSerialization.jsonObject(with: encodedData, options: []) as? [String: Any]
            return setData(jsonObject ?? [:], forDocument: document)
        }

        @discardableResult
        func setEncodableData(
            _ value: (some Encodable)?,
            forDocument document: DocumentReference,
            merge: Bool,
            with encoder: JSONEncoder = .init()
        ) throws -> WriteBatch {
            let encodedData = try encoder.encode(value)
            let jsonObject = try JSONSerialization.jsonObject(with: encodedData, options: []) as? [String: Any]
            return setData(jsonObject ?? [:], forDocument: document, merge: merge)
        }

        /// Force WriteBatch to commit data offline (and synchronously) even when the calling function is asynchronous.
        func commitSync() {
            commit()
        }
    }
#endif
