import Foundation

public extension JSONValue {
    func asDictionary () -> [NSString:JSONValue]? {
        
        if case let .JSONDictionary(dict) = self {
            return dict
        }
        
        return nil
    }
    
    func asArray () -> [JSONValue]? {
        if case let .JSONArray(array) = self {
            return array
        }
        
        return nil
    }
    
    func asString () -> String? {
        if case let .JSONString(string) = self {
            return string as String
        }
        
        return nil
    }
    
    func asNumber () -> NSNumber? {
        if case let .JSONNumber(number) = self {
            return number
        }
        
        return nil
    }
    
    func asBool () -> Bool? {
        if case let .JSONBool(bool) = self {
            return bool.boolValue
        }
        
        return nil
    }
    
    func asError () -> (Bool, NSError?)? {
        if case let .JSONError(error) = self {
            return (true, error)
        }
        
        return (false, nil)
    }
    
    func isNull () -> Bool {
        if case .JSONNull = self {
            return true
        }
        
        return false
    }
    
}

public extension JSONValue {
    var dictionary : [NSString:JSONValue]! {
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
