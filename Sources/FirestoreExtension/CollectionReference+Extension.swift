//
//  CollectionReference+Extension.swift
//
//
//  Created by longvu on 08/09/2022.
//

import FirebaseFirestore

public extension CollectionReference {
    func addEncodableDocument(
        _ value: some Encodable,
        encoder: JSONEncoder = .init()
    ) throws -> DocumentReference {
        let encodedData = try encoder.encode(value)
        let jsonObject = try JSONSerialization.jsonObject(with: encodedData, options: []) as? [String: Any]
        return addDocument(data: jsonObject ?? [:])
    }
}
