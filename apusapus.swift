import Foundation

public enum JSONValue {
    case jsonDictionary([NSString: JSONValue])
    case jsonArray([JSONValue])
    case jsonString(NSString)
    case jsonNumber(NSNumber)
    case jsonBool(NSNumber)
    case jsonNull
}

public extension JSONValue {

    static func fromJSONObject(_ object: Any) -> JSONValue {
        switch object {
        case _ as NSNull:
            return JSONValue.jsonNull
        case let dict as NSDictionary:
            var jsonDict = [NSString:JSONValue]()
            dict.enumerateKeysAndObjects({ (key, object, stop) -> Void in
                if let keyString = key as? NSString {
                    jsonDict[keyString] = JSONValue.fromJSONObject(object)
                }
            })

            return JSONValue.jsonDictionary(jsonDict)
        case let array as NSArray:
            var jsonArray = [JSONValue]()
            jsonArray.reserveCapacity(array.count)

            array.enumerateObjects({ (object, index, stop) -> Void in
                jsonArray.append(JSONValue.fromJSONObject(object))
            })

            return JSONValue.jsonArray(jsonArray)
        case let number as NSNumber:
            if number.objCType.pointee == 99 {
                return JSONValue.jsonBool(number)
            } else {
                return JSONValue.jsonNumber(number)
            }
        case let string as String :
            return JSONValue.jsonString(string as NSString)
        default:
            return JSONValue.jsonNull
        }
    }

    static func fromJSONData(_ data: Data) throws -> JSONValue {
        do {
            let jsonObject: Any =
                try JSONSerialization.jsonObject(
                        with: data,
                        options: JSONSerialization.ReadingOptions.allowFragments)
            return JSONValue.fromJSONObject(jsonObject)
        } catch let error as NSError {
            throw error
        }
    }
}

extension JSONValue {

    public var count: Int {
        get {
            switch self {
            case let .jsonArray(array):
                return array.count
            case let .jsonDictionary(dict):
                return dict.count
            default:
                return 0
            }
        }
    }

    public subscript(index: Int) -> JSONValue {
        get {
            switch self {
            case let .jsonArray(array):
                precondition(index >= 0 && index < array.count, "Array index out of bounds")
                return array[index]
            default:
                return .jsonNull
            }
        }
    }

    public subscript(key: String) -> JSONValue {
        get {
            switch self {
            case let .jsonDictionary(dict as [String: JSONValue]):
                return dict[key] ?? .jsonNull
            default:
                return .jsonNull
            }
        }
    }

}
