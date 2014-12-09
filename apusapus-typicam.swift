

public extension JSONValue {
    func asDictionary () -> [String:JSONValue]? {
        
        switch self {
        case let .JSONDictionary(dict):
            return dict
        default:
            return nil
        }
    }
    
    func asArray () -> [JSONValue]? {
        switch self {
        case let .JSONArray(array):
            return array
        default:
            return nil
        }
    }
    
    func asString () -> String? {
        switch self {
        case let .JSONString(string):
            return string
        default:
            return nil
        }
    }
    
    func asNumber () -> NSNumber? {
        switch self {
        case let .JSONNumber(number):
            return number
        default:
            return nil
        }
    }
    
    func asBool () -> Bool? {
        switch self {
        case let .JSONBool(bool):
            return bool
        default:
            return nil
        }
    }
    
    func asError () -> (Bool, NSError?)? {
        switch self {
        case let .JSONError(error):
            return (true, error)
        default:
            return (false, nil)
        }
    }
    
    func isNull () -> Bool {
        switch self {
        case let .JSONNull:
            return true
        default:
            return false
        }
    }
    
}

public extension JSONValue {
    var dictionary : [String:JSONValue]! {
        get {
            return asDictionary()
        }
    }
    
    var array : [JSONValue]! {
        get {
            return asArray()
        }
    }
    
    var string: String! {
        get {
            return asString()
        }
    }
    
    var number: NSNumber! {
        get {
            return asNumber()
        }
    }
    
    var bool: Bool! {
        get {
            return asBool()
        }
    }
    
    var error: (Bool, NSError?)! {
        get {
            return asError()
        }
    }
}
