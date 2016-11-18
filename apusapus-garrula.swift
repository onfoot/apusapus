import Foundation

extension JSONValue : CustomStringConvertible {
    public var description: String {
        get {
            switch self {
            case let .jsonString(string):
                let escapedString =
                    string.replacingOccurrences(of: "\"", with: "\\\"")
                return "\"\(escapedString)\""
            case let .jsonBool(number):
                return number.boolValue ? "true" : "false"
            case let .jsonDictionary(jsonObject):
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
            case let .jsonNumber(number):
                return "\(number)"
            case let .jsonArray(array):
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
            case .jsonNull:
                return "null"
            }
        }
    }
}
