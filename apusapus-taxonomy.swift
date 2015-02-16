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
            
        case let .JSONArray:
            
            if self.asArray() != nil {
                return true
            }
            
        case let .JSONStringOptional:
            if self.isNull() || self.asString() != nil {
                return true
            }
            
        case let .JSONNumberOptional:
            if self.isNull() || self.asNumber() != nil {
                return true
            }
            
        case let .JSONDictionary(descriptionDictionary):
            
            var isValid = true
            
            if let dictionary = self.asDictionary() {
                
                for (key, value) in descriptionDictionary {
                        if dictionary[key] == nil || (dictionary[key] != nil && !dictionary[key]!.matchesDescription(value)) {
                            isValid = false
                        }
                }
                
            } else {
                isValid = false
            }
            
            return isValid
            
        default:
            break
        }

        return false
    }
}
