import Foundation

/// Concrete implementation of ProfileUseCase.
/// Depends only on the ProfileRepositoryPort interface — never on any infrastructure type.
public final class ProfileUseCaseImpl: ProfileUseCase {
    private let repository: ProfileRepositoryPort

    public init(repository: ProfileRepositoryPort) {
        self.repository = repository
    }

    public func getUserProfile(id: UUID) async throws -> User {
        try await repository.fetchUser(id: id)
    }

    public func updateUserProfile(user: User) async throws -> User {
        try await repository.saveUser(user)
    }
}
