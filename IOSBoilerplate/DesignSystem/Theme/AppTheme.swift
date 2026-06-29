struct AppTheme {
    let environment: AppEnvironment

    init(environment: AppEnvironment = .development) {
        self.environment = environment
    }
}
