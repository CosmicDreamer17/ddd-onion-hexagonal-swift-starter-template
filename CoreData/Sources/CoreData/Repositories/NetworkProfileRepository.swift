import Foundation
import CoreDomain

/// Production ProfileRepositoryPort that communicates with a remote API.
/// Replace the TODO stubs with real URLSession calls once your backend is ready.
public final class NetworkProfileRepository: ProfileRepositoryPort {
    private let configuration: AppConfiguration
    private let session: URLSession

    public init(configuration: AppConfiguration, session: URLSession = .shared) {
        self.configuration = configuration
        self.session = session
    }

    public func fetchUser(id: UUID) async throws -> User {
        // TODO: Implement
        // let url = configuration.baseURL.appendingPathComponent("users/\(id.uuidString)")
        // var request = URLRequest(url: url)
        // request.setValue("Bearer \(configuration.apiKey)", forHTTPHeaderField: "Authorization")
        // let (data, response) = try await session.data(for: request)
        // guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
        //     let code = (response as? HTTPURLResponse)?.statusCode ?? -1
        //     throw DomainError.networkError("HTTP \(code)")
        // }
        // return try JSONDecoder().decode(User.self, from: data)
        throw DomainError.networkError("NetworkProfileRepository is not yet implemented")
    }

    public func saveUser(_ user: User) async throws -> User {
        // TODO: Implement
        // let url = configuration.baseURL.appendingPathComponent("users/\(user.id.uuidString)")
        // var request = URLRequest(url: url)
        // request.httpMethod = "PUT"
        // request.setValue("Bearer \(configuration.apiKey)", forHTTPHeaderField: "Authorization")
        // request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // request.httpBody = try JSONEncoder().encode(user)
        // let (data, _) = try await session.data(for: request)
        // return try JSONDecoder().decode(User.self, from: data)
        throw DomainError.networkError("NetworkProfileRepository is not yet implemented")
    }
}
