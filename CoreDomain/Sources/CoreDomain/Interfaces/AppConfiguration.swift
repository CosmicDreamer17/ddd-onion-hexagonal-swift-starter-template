import Foundation

public protocol AppConfiguration {
    var baseURL: URL { get }
    var apiKey: String { get }
    var environment: AppEnvironment { get }
}

public enum AppEnvironment: String {
    case development
    case staging
    case production
}
