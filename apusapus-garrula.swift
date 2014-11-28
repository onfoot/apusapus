

extension JSONValue : Printable {
    public var description : String {
        get {
            switch self {
            case let .JSONString(string):
                var escapedString = string.stringByReplacingOccurrencesOfString("\"", withString: "\\\"")
                return "\"\(escapedString)\""
            case let .JSONBool(bool):
                return bool ? "true" : "false"
            case let .JSONDictionary(jsonObject):
                var descr = "{"
                var first = true

                for (key, value) in jsonObject {
                    if !first {
                        descr += ","
                    }
                    
                    descr += String("\n\t\"" + key + "\" : " + value.description)
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
            case let .JSONNull:
                return "null"
            case let .JSONError(error):
                if error != nil {
                    return "Error: \(error!.description)\n"
                }
                
                return "Error\n"
            default:
                return "<UNKNOWN TYPE>\n"
            }
        }
    }
}
