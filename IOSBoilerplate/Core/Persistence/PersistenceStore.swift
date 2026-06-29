protocol PersistenceStore {
    func save<Value: Encodable>(_ value: Value, forKey key: String) throws
    func load<Value: Decodable>(_ type: Value.Type, forKey key: String) throws -> Value?
    func removeValue(forKey key: String) throws
}
