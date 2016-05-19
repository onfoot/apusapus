import Foundation

public protocol ApusDecodable {
    static var jsonDescription : JSONDescription { get }
    static func decode(j: JSONValue) throws -> Self
}

func DecodeArray<Type : ApusDecodable>(v: JSONValue, failOnError: Bool = true) throws -> [Type] {
    guard let array = v.asArray() else {
        throw NSError(domain: "apus-apus", code: 406, userInfo: ["details": "DecodeArray - JSONValue is not a JSONArray"])
    }
    
    var items = [Type]()

    for value in array {
        do {
            let item = try Type.decode(value)
            items.append(item)
        } catch let err as NSError {
            if failOnError {
                throw err
            } else {
                continue
            }
        }
    }
    
    return items
}

func DecodeArray<Type : ApusDecodable>(v: JSONValue, failOnError: Bool = true, bySpreading spread: (Type) -> (key: String, value: Type)) throws -> [String: Type] {
    guard let array = v.asArray() else {
        throw NSError(domain: "apus-apus", code: 406, userInfo: ["details": "DecodeArray - JSONValue is not a JSONArray"])
    }
    
    var items = [String: Type]()
    
    for value in array {
        do {
            let (key, item) = spread(try Type.decode(value))
            items[key] = item
        } catch let err as NSError {
            if failOnError {
                throw err
            } else {
                continue
            }
        }
    }
    
    return items
}

func DecodeDictionary<Type : ApusDecodable>(v: JSONValue, failOnError: Bool = true) throws -> [String: Type] {
    guard let array = v.asDictionary() else {
        throw NSError(domain: "apus-apus", code: 406, userInfo: ["details": "DecodeDictionary - JSONValue is not a JSONDictionary"])
    }
    
    var items = [String: Type]()
    
    for (key, value) in array {
        do {
            let item = try Type.decode(value)
            items[key as String] = item
        } catch let err as NSError {
            if failOnError {
                throw err
            } else {
                continue
            }
        }
    }
    
    return items
}
