import Foundation

public protocol ProfileUseCase {
    func getUserProfile(id: UUID) async throws -> User
    func updateUserProfile(user: User) async throws -> User
}
