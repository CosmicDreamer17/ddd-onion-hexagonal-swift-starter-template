import Foundation

public enum DomainError: Error, Equatable {
    case notFound
    case unauthorized
    case networkError(String)
    case unknown
}
