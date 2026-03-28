import Foundation

public struct UserDefaultsValueStore<Value: Codable & Sendable>: @unchecked Sendable {
    public let key: String
    public let defaults: UserDefaults

    public init(key: String, defaults: UserDefaults = .standard) {
        self.key = key
        self.defaults = defaults
    }

    public func load() -> Value? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(Value.self, from: data)
    }

    public func save(_ value: Value?) {
        guard let value else {
            defaults.removeObject(forKey: key)
            return
        }

        if let data = try? JSONEncoder().encode(value) {
            defaults.set(data, forKey: key)
        }
    }
}
