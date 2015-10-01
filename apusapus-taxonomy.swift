import Foundation

public enum JSONDescription {
    case JSONDictionary([NSString:JSONDescription])
    case JSONArray
    case JSONString
    case JSONNumber
    case JSONBool
    case JSONStringOptional
    case JSONNumberOptional
}

public extension JSONValue {
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
            
        case .JSONStringOptional:
            if self.isNull() || self.asString() != nil {
                return true
            }
            
        case .JSONNumberOptional:
            if self.isNull() || self.asNumber() != nil {
                return true
            }
            
        case let .JSONDictionary(descriptionDictionary):
            guard let dictionary = self.asDictionary() else {
                return false
            }
            
            var isValid = true
            
            for (key, value) in descriptionDictionary {
                if dictionary[key] == nil || (dictionary[key] != nil && !dictionary[key]!.matchesDescription(value)) {
                    isValid = false
                }
            }
            
            return isValid
        }

        return false
    }
}
