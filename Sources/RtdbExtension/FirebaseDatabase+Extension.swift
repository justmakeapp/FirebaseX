// Created 13/02/2022

import FirebaseDatabase

public extension DataSnapshot {
    var childSnapshots: [DataSnapshot] { children.compactMap { $0 as? DataSnapshot } }

    var string: String? {
        return value as? String
    }

    var stringValue: String {
        return value as? String ?? ""
    }

    var dateEpochInSecondsFrom1970: Date? {
        guard let interval = value as? TimeInterval else {
            return nil
        }
        return Date(timeIntervalSince1970: interval)
    }

    var bool: Bool {
        return value as? Bool ?? false
    }

    var boolValue: Bool {
        return value as? Bool ?? false
    }

    func decodableValue<Value: Decodable>(_ type: Value.Type, decoder: JSONDecoder = .init()) throws -> Value {
        // Only allow top-level json object
        guard exists(), let dataValue = value, dataValue is [Any] || dataValue is [String: Any] else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: ""))
        }
        let data = try JSONSerialization.data(withJSONObject: dataValue, options: [])
        return try decoder.decode(type, from: data)
    }

    func rawRepresentableValue<Value: RawRepresentable>(
        _: Value.Type,
        transformer: @escaping ((Any?) -> Value.RawValue?) = { $0 as? Value.RawValue }
    ) -> Value? {
        guard let dataValue = transformer(value),
              let convertedValue = Value(rawValue: dataValue) else {
            return nil
        }
        return convertedValue
    }
}

public extension DatabaseReference {
    func setValueSync(_ value: Any?) {
        setValue(value)
    }

    func setEncodableValue(_ value: some Encodable,
                           with encoder: JSONEncoder = .init(),
                           completionBlock: ((Error?, DatabaseReference) -> Void)? = nil) throws {
        let encodedData = try encoder.encode(value)
        let jsonObject = try JSONSerialization.jsonObject(with: encodedData, options: [])

        if let serverCompletionBlock = completionBlock {
            setValue(jsonObject, withCompletionBlock: serverCompletionBlock)
        } else {
            setValue(jsonObject)
        }
    }

    func updateEncodableValue(_ value: some Encodable, with encoder: JSONEncoder = .init()) throws {
        let encodedData = try encoder.encode(value)
        let jsonObject = try JSONSerialization.jsonObject(with: encodedData, options: [])
        guard let childValue = jsonObject as? [AnyHashable: Any] else {
            return
        }
        let _: Void = updateChildValues(childValue)
    }
}
