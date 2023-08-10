//
//  DocumentReference+Extension.swift
//
//
//  Created by Long Vu on 11/04/2023.
//

import FirebaseFirestore

public extension DocumentReference {
    func setData(_ encodableData: some Encodable, encoder: JSONEncoder = .init()) throws {
        let encodedData = try encoder.encode(encodableData)
        guard let jsonObject = try JSONSerialization.jsonObject(with: encodedData, options: []) as? [String: Any] else {
            throw NSError(
                domain: "",
                code: 1_000,
                userInfo: [NSLocalizedDescriptionKey: "Can not cast to json object"]
            )
        }
        setData(jsonObject)
    }

    /// Force write data offline (and synchronously) even when the calling function is asynchronous.
    func setDataSync(_ documentData: [String: Any], merge: Bool = false) {
        setData(documentData, merge: merge)
    }

    /// Force update data offline (and synchronously) even when the calling function is asynchronous.
    func updateDataSync(_ fields: [AnyHashable: Any]) {
        updateData(fields)
    }

    /// Force delete data offline (and synchronously) even when the calling function is asynchronous.
    func deleteSync() {
        delete()
    }
}
