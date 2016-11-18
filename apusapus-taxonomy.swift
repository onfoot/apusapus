import Foundation

public enum JSONDescription {
    case jsonDictionary([NSString:JSONDescription])
    case jsonArray
    case jsonString
    case jsonNumber
    case jsonBool
    indirect case jsonOptional(JSONDescription)
}

public enum TaxonomyResult {
    case valid
    case invalid(field: String, message: String)
}

public extension JSONValue {
    // swiftlint:disable cyclomatic_complexity
    func matchesDescription(_ description: JSONDescription) -> Bool {
        switch description {
        case .jsonString:

            if self.asString() != nil {
                return true
            }

        case .jsonBool:

            if self.asBool() != nil {
                return true
            }

        case .jsonNumber:

            if self.asNumber() != nil {
                return true
            }

        case .jsonArray:

            if self.asArray() != nil {
                return true
            }

        case let .jsonOptional(optionalDescription):
            if self.isNull() {
                return true
            }

            switch optionalDescription {
            case .jsonOptional:
                return false
            default:
                return self.matchesDescription(optionalDescription)
            }

        case let .jsonDictionary(descriptionDictionary):
            guard let dictionary = self.asDictionary() else {
                return false
            }

            var isValid = true

            for (key, value) in descriptionDictionary {
                if dictionary[key] == nil ||
                    (dictionary[key] != nil && !dictionary[key]!.matchesDescription(value)) {
                    isValid = false
                }
            }

            return isValid
        }

        return false
    }


    func validateDescription(_ description: JSONDescription) -> TaxonomyResult {
        switch description {
        case .jsonString:

            if self.asString() != nil {
                return .valid
            }

            return .invalid(field: self.description, message: "Should be String")

        case .jsonBool:

            if self.asBool() != nil {
                return .valid
            }

            return .invalid(field: self.description, message: "Should be Bool")

        case .jsonNumber:

            if self.asNumber() != nil {
                return .valid
            }

            return .invalid(field: self.description, message: "Should be a Number")

        case .jsonArray:

            if self.asArray() != nil {
                return .valid
            }

            return .invalid(field: self.description, message: "Should be an Array")

        case let .jsonOptional(optionalDescription):
            if self.isNull() {
                return .valid
            }

            switch optionalDescription {
            case .jsonOptional:
                return .invalid(field: self.description, message: "Should be an Optional")
            default:
                return self.validateDescription(optionalDescription)
            }

        case let .jsonDictionary(descriptionDictionary):
            guard let dictionary = self.asDictionary() else {
                return .invalid(field: self.description, message: "Should be a Dictionary")
            }

            for (key, value) in descriptionDictionary {
                if dictionary[key] == nil {
                    continue
                }

                let elementResult = dictionary[key]!.validateDescription(value)
                if case let .invalid(field, _) = elementResult {
                    return .invalid(field: key as String, message: "Value \(field) should be a \(value)")
                }
            }

            return .valid
        }
    }

}
