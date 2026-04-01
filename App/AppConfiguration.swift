import Foundation
import CoreDomain

/// Concrete AppConfiguration that reads from Info.plist at launch.
/// Set APP_ENVIRONMENT and API_BASE_URL as build settings in your target,
/// then reference them in Info.plist. Never commit raw credentials to source.
struct DefaultAppConfiguration: AppConfiguration {
    let baseURL: URL
    let apiKey: String
    let environment: AppEnvironment

    // swiftlint:disable:next force_unwrap
    private static let fallbackBaseURL = URL(string: "https://api.example.com")! // compile-time literal, always valid

    static let current: DefaultAppConfiguration = {
        let envString = Bundle.main.infoDictionary?["APP_ENVIRONMENT"] as? String ?? "development"
        let environment = AppEnvironment(rawValue: envString) ?? .development

        let baseURLString: String
        switch environment {
        case .production:
            baseURLString = Bundle.main.infoDictionary?["API_BASE_URL"] as? String ?? "https://api.example.com"
        case .staging:
            baseURLString = "https://staging-api.example.com"
        case .development:
            baseURLString = "http://localhost:8080"
        }

        let baseURL = URL(string: baseURLString) ?? fallbackBaseURL
        let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String ?? ""

        return DefaultAppConfiguration(baseURL: baseURL, apiKey: apiKey, environment: environment)
    }()
}
