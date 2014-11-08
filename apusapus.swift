import Foundation

public enum JSONValue {
    case JSONDictionary([String:JSONValue])
    case JSONArray([JSONValue])
    case JSONString(String)
    case JSONNumber(Double)
    case JSONBool(Bool)
    case JSONNull
    
    case JSONError(NSError?)
    
    static func fromJSONObject(object : AnyObject) -> JSONValue {
        switch object {
        case let null as NSNull:
            return JSONValue.JSONNull
        case let dict as NSDictionary:
            var jsonDict : [String:JSONValue] = [:]
            
            dict.enumerateKeysAndObjectsUsingBlock({ (keyObject, valueObject, stop) -> Void in
                if let keyString = keyObject as? String {
                    jsonDict[keyString] = JSONValue.fromJSONObject(valueObject!)
                }
            })
            
            return JSONValue.JSONDictionary(jsonDict)
        case let array as NSArray:
            var jsonArray : [JSONValue] = []
            array.enumerateObjectsUsingBlock({ (valueObject, index, stop) -> Void in
                jsonArray.append(JSONValue.fromJSONObject(valueObject))
            })
            return JSONValue.JSONArray(jsonArray)
        case let number as NSNumber:
            let typeString = NSString(CString: number.objCType, encoding: NSASCIIStringEncoding)!
            if typeString == "c" {
                return JSONValue.JSONBool(number.boolValue)
            } else {
                return JSONValue.JSONNumber(number.doubleValue)
            }
        case let string as String :
            return JSONValue.JSONString(string)
        default:
            return JSONValue.JSONError(nil)
        }
    }
}


public extension JSONValue {
    static func fromJSONData(data: NSData) -> JSONValue {
        var error : NSError?
        if let jsonObject: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &error) {
            return JSONValue.fromJSONObject(jsonObject)
        }
        
        return JSONValue.JSONError(error)
    }
}

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
