import OSLog

enum AppLogger {
    static let app = Logger(subsystem: "com.ifanramadhany.Triply", category: "App")
    static let networking = Logger(subsystem: "com.ifanramadhany.Triply", category: "Networking")
}
