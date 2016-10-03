import Foundation

public enum JSONDescription {
    case JSONDictionary([NSString:JSONDescription])
    case JSONArray
    case JSONString
    case JSONNumber
    case JSONBool
    indirect case JSONOptional(JSONDescription)
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
}
