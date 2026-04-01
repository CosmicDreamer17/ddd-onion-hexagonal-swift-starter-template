import Foundation

/// The hexagonal port that the infrastructure layer must implement.
/// Defined in CoreDomain so that the dependency arrow always points inward.
public protocol ProfileRepositoryPort {
    func fetchUser(id: UUID) async throws -> User
    func saveUser(_ user: User) async throws -> User
}
