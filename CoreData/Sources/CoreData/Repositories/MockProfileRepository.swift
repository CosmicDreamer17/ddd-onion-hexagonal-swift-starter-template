import Foundation
import CoreDomain

/// In-memory ProfileRepositoryPort implementation for development and previews.
/// Seeded with one user so the app runs without a backend.
/// Replace with NetworkProfileRepository for staging/production.
public final class InMemoryProfileRepository: ProfileRepositoryPort {
    private var users: [UUID: User] = [:]

    public init() {
        let id = UUID(uuidString: "00000000-0000-0000-0000-000000000001") ?? UUID()
        users[id] = User(id: id, username: "agent_smith", email: "smith@matrix.com", bio: "Autonomous AI Agent")
    }

    public func fetchUser(id: UUID) async throws -> User {
        try await Task.sleep(nanoseconds: 300_000_000)
        guard let user = users[id] else {
            throw DomainError.notFound
        }
        return user
    }

    public func saveUser(_ user: User) async throws -> User {
        try await Task.sleep(nanoseconds: 300_000_000)
        users[user.id] = user
        return user
    }
}
