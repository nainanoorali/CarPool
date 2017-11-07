import CoreLocation

public struct Event: Codable, Keyed {
    public var key: String!

    enum CodingKey: String {
        case location = "geohash"
        case description
        case time
        case owner
    }

    public let description: String
    public let owner: User
    public let time: Date

    let geohash: String

    public var location: CLLocation? {
        return Geohash(value: geohash)?.location
    }
}

func checkIsValidJsonType(_ any: Any) throws {
    if let _ = any as? NSNumber {
        throw API.Error.invalidJsonType
    }
    if let _ = any as? NSString {
        throw API.Error.invalidJsonType
    }
    if any is NSNull {
        throw API.Error.invalidJsonType
    }
}

extension Event {
    init(json: [String: Any], key: String) throws {
        print(#function, json)
        guard let (key, json) = (json["event"] as? [String: Any])?.first else {
            throw API.Error.decode
        }
        try checkIsValidJsonType(json)
        let data = try JSONSerialization.data(withJSONObject: json)
        self = try JSONDecoder().decode(Event.self, from: data)
        self.key = key
    }
}
