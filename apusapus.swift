import Foundation

public enum JSONValue {
    case JSONDictionary([String:JSONValue])
    case JSONArray([JSONValue])
    case JSONString(String)
    case JSONNumber(NSNumber)
    case JSONBool(Bool)
    case JSONNull
    case JSONError(NSError?)
}

public extension JSONValue {
    
    static func fromJSONObject(object : AnyObject) -> JSONValue {
        switch object {
        case let null as NSNull:
            return JSONValue.JSONNull
        case let dict as NSDictionary:
            var jsonDict : [String:JSONValue] = [:]
            
            for key in dict.allKeys {
                if let keyString = key as? String {
                    jsonDict[keyString] = JSONValue.fromJSONObject(dict[keyString]!)
                }
            }
            
            return JSONValue.JSONDictionary(jsonDict)
        case let array as NSArray:
            var jsonArray = [JSONValue]()
            jsonArray.reserveCapacity(array.count)

            for valueObject in array {
                jsonArray.append(JSONValue.fromJSONObject(valueObject))
            }
            
            return JSONValue.JSONArray(jsonArray)
        case let number as NSNumber:
            let typeString = NSString(CString: number.objCType, encoding: NSASCIIStringEncoding)!
            if typeString == "c" {
                return JSONValue.JSONBool(number.boolValue)
            } else {
                return JSONValue.JSONNumber(number)
            }
        case let string as String :
            return JSONValue.JSONString(string)
        default:
            return JSONValue.JSONError(nil)
        }
    }

    static func fromJSONData(data: NSData) -> JSONValue {
        var error : NSError?
        if let jsonObject: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &error) {
            return JSONValue.fromJSONObject(jsonObject)
        }
        
        return JSONValue.JSONError(error)
    }
}
