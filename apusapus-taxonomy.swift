import Foundation

public enum JSONDescription {
    case JSONDictionary([NSString:JSONDescription])
    case JSONArray
    case JSONString
    case JSONNumber
    case JSONBool
    indirect case JSONOptional(JSONDescription)
}

public enum TaxonomyResult {
    case Valid
    case Invalid(field: String, message: String)
}

public extension JSONValue {
    // swiftlint:disable cyclomatic_complexity
    func matchesDescription(description: JSONDescription) -> Bool {
        switch description {
        case .JSONString:

            if self.asString() != nil {
                return true
            }

        case .JSONBool:

            if self.asBool() != nil {
                return true
            }

        case .JSONNumber:

            if self.asNumber() != nil {
                return true
            }

        case .JSONArray:

            if self.asArray() != nil {
                return true
            }

        case let .JSONOptional(optionalDescription):
            if self.isNull() {
                return true
            }

            switch optionalDescription {
            case .JSONOptional:
                return false
            default:
                return self.matchesDescription(optionalDescription)
            }

        case let .JSONDictionary(descriptionDictionary):
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


    func validateDescription(description: JSONDescription) -> TaxonomyResult {
        switch description {
        case .JSONString:

            if self.asString() != nil {
                return .Valid
            }

            return .Invalid(field: self.description, message: "Should be String")

        case .JSONBool:

            if self.asBool() != nil {
                return .Valid
            }

            return .Invalid(field: self.description, message: "Should be Bool")

        case .JSONNumber:

            if self.asNumber() != nil {
                return .Valid
            }

            return .Invalid(field: self.description, message: "Should be a Number")

        case .JSONArray:

            if self.asArray() != nil {
                return .Valid
            }

            return .Invalid(field: self.description, message: "Should be an Array")

        case let .JSONOptional(optionalDescription):
            if self.isNull() {
                return .Valid
            }

            switch optionalDescription {
            case .JSONOptional:
                return .Invalid(field: self.description, message: "Should be an Optional")
            default:
                return self.validateDescription(optionalDescription)
            }

        case let .JSONDictionary(descriptionDictionary):
            guard let dictionary = self.asDictionary() else {
                return .Invalid(field: self.description, message: "Should be a Dictionary")
            }

            for (key, value) in descriptionDictionary {
                if dictionary[key] == nil {
                    continue
                }

                let elementResult = dictionary[key]!.validateDescription(value)
                if case let .Invalid(field, _) = elementResult {
                    return .Invalid(field: key as String, message: "Value \(field) should be a \(value)")
                }
            }

            return .Valid
        }
    }

}
