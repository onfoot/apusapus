import Foundation

extension JSONValue : CustomStringConvertible {
    public var description: String {
        get {
            switch self {
            case let .JSONString(string):
                let escapedString =
                    string.stringByReplacingOccurrencesOfString("\"", withString: "\\\"")
                return "\"\(escapedString)\""
            case let .JSONBool(number):
                return number.boolValue ? "true" : "false"
            case let .JSONDictionary(jsonObject):
                var descr = "{"
                var first = true

                for (key, value) in jsonObject {
                    if !first {
                        descr += ","
                    }

                    descr += String("\n\t\"" + (key as String) + "\" : " + value.description)
                    first = false
                }
                descr += "\n}"
                return descr
            case let .JSONNumber(number):
                return "\(number)"
            case let .JSONArray(array):
                var descr = "["
                var first = true
                for value in array {
                    if !first {
                        descr += ","
                    }

                    descr += String("\n" + value.description)
                    first = false
                }
                descr += "\n]"
                return descr
            case .JSONNull:
                return "null"
            }
        }
    }
}
