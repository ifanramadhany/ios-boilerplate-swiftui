protocol PersistenceStore {
    func save(_ value: some Encodable, forKey key: String) throws
    func load<Value: Decodable>(_ type: Value.Type, forKey key: String) throws -> Value?
    func removeValue(forKey key: String) throws
}
