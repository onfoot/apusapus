import Foundation

public enum JSONValue {
    case JSONDictionary([String:JSONValue])
    case JSONArray([JSONValue])
    case JSONString(String)
    case JSONNumber(Double)
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

    static func fromJSONData(data: NSData) -> JSONValue {
        var error : NSError?
        if let jsonObject: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &error) {
            return JSONValue.fromJSONObject(jsonObject)
        }
        
        return JSONValue.JSONError(error)
    }
}
