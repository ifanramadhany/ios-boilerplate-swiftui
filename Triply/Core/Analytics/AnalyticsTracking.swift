protocol AnalyticsTracking {
    func track(event: AnalyticsEvent)
}

struct AnalyticsEvent: Equatable {
    let name: String
    let parameters: [String: String]

    init(name: String, parameters: [String: String] = [:]) {
        self.name = name
        self.parameters = parameters
    }
}
