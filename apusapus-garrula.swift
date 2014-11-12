

extension JSONValue : Printable {
    public var description : String {
        get {
            switch self {
            case let .JSONString(string):
                return "\"\(string)\"\n"
            case let .JSONBool(bool):
                return bool ? "true\n" : "false\n"
            case let .JSONDictionary(jsonObject):
                var descr = "{\n"
                for (key, value) in jsonObject {
                    descr += String("\t\"" + key + "\" : " + value.description + "\n")
                }
                descr += "}\n"
                return descr
            case let .JSONNumber(number):
                return "\(number)"
            case let .JSONArray(array):
                var descr = "["
                var first = true
                for value in array {
                    if !first {
                        descr += ", "
                    }
                    descr += value.description
                    first = false
                }
                descr += "]\n"
                return descr
            case let .JSONNull:
                return "NULL\n"
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
