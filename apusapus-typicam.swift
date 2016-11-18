import Foundation

public extension JSONValue {
    func asDictionary () -> [NSString:JSONValue]? {

        if case let .jsonDictionary(dict) = self {
            return dict
        }

        return nil
    }

    func asArray () -> [JSONValue]? {
        if case let .jsonArray(array) = self {
            return array
        }

        return nil
    }

    func asString () -> String? {
        if case let .jsonString(string) = self {
            return string as String
        }

        return nil
    }

    func asNumber () -> NSNumber? {
        if case let .jsonNumber(number) = self {
            return number
        }

        return nil
    }

    func asBool () -> Bool? {
        if case let .jsonBool(bool) = self {
            return bool.boolValue
        }

        return nil
    }

    func isNull () -> Bool {
        if case .jsonNull = self {
            return true
        }

        return false
    }

}

public extension JSONValue {
    var dictionary: [NSString:JSONValue]! {
        get {
            return asDictionary()
        }
    }

    var array: [JSONValue]! {
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
}
