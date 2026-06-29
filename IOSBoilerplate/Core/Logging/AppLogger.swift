import OSLog

enum AppLogger {
    static let app = Logger(subsystem: "com.ifanramadhany.IOSBoilerplate", category: "App")
    static let networking = Logger(subsystem: "com.ifanramadhany.IOSBoilerplate", category: "Networking")
}
