import Foundation

public enum JSONValue {
    case JSONDictionary([NSString:JSONValue])
    case JSONArray([JSONValue])
    case JSONString(NSString)
    case JSONNumber(NSNumber)
    case JSONBool(NSNumber)
    case JSONNull
}

public extension JSONValue {
    
    static func fromJSONObject(object : AnyObject) -> JSONValue {
        switch object {
        case _ as NSNull:
            return JSONValue.JSONNull
        case let dict as NSDictionary:
            var jsonDict = [NSString:JSONValue]()
            dict.enumerateKeysAndObjectsUsingBlock({ (key, object, stop) -> Void in
                if let keyString = key as? NSString {
                    jsonDict[keyString] = JSONValue.fromJSONObject(object)
                }
            })
            
            return JSONValue.JSONDictionary(jsonDict)
        case let array as NSArray:
            var jsonArray = [JSONValue]()
            jsonArray.reserveCapacity(array.count)

            array.enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                jsonArray.append(JSONValue.fromJSONObject(object))
            })
            
            return JSONValue.JSONArray(jsonArray)
        case let number as NSNumber:
            if number.objCType.memory == 99 {
                return JSONValue.JSONBool(number)
            } else {
                return JSONValue.JSONNumber(number)
            }
        case let string as String :
            return JSONValue.JSONString(string)
        default:
            return JSONValue.JSONNull
        }
    }

    static func fromJSONData(data: NSData) throws -> JSONValue {
        do {
            let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
            return JSONValue.fromJSONObject(jsonObject)
        } catch let error as NSError {
            throw error
        }
    }
}

extension JSONValue {

    public var count : Int {
        get {
            switch self {
            case let .JSONArray(array):
                return array.count
            case let .JSONDictionary(dict):
                return dict.count
            default:
                return 0
            }
        }
    }
    
    
    public subscript(index: Int) -> JSONValue {
        get {
            switch self {
            case let .JSONArray(array):
                precondition(index >= 0 && index < array.count, "Array index out of bounds")
                return array[index]
            default:
                return .JSONNull
            }
        }
    }
    
    public subscript(key: String) -> JSONValue {
        get {
            switch self {
            case let .JSONDictionary(dict):
                if let value = dict[key] {
                    return value
                } else {
                    return .JSONNull
                }
            default:
                return .JSONNull
            }
        }
    }

}