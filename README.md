More Swifty approach to parsing JSON.

It's a thin layer over NSJSONSerialization APIs and its main use case is parsing a JSON object received in e.g. n remote API call response.

There's no mapping provided.

Basics
======

JSON data is wrapped with a structure of `JSONValue` enum types and made accessible using either optional type-safe accessors (`asArray`, `asDictionary`, `asNumber`, `asString`, `asBool`) or array/dictionary subscript accessors.

Optionally you can verify the incoming JSON message's schema using a `JSONDescription` structure. If you do that, you can safely use force-unwrapped type accessors (`array`, `dictionary`, `number`, `string`, `bool`) to reduce the amount of type checks in parsing code.
