import Testing
import Foundation
@testable import CoreDomain

// MARK: - Test double for ProfileUseCaseImpl tests

private final class MockRepository: ProfileRepositoryPort {
    var usersById: [UUID: User] = [:]
    var errorToThrow: DomainError?

    func fetchUser(id: UUID) async throws -> User {
        if let error = errorToThrow { throw error }
        guard let user = usersById[id] else { throw DomainError.notFound }
        return user
    }

    func saveUser(_ user: User) async throws -> User {
        if let error = errorToThrow { throw error }
        usersById[user.id] = user
        return user
    }
}

// MARK: - User entity

@Suite("User Entity")
struct UserTests {
    @Test func createsWithAllFields() {
        let id = UUID()
        let user = User(id: id, username: "alice", email: "alice@example.com", bio: "Developer")
        #expect(user.id == id)
        #expect(user.username == "alice")
        #expect(user.email == "alice@example.com")
        #expect(user.bio == "Developer")
    }

    @Test func defaultsToRandomId() {
        let a = User(username: "a", email: "a@a.com", bio: "")
        let b = User(username: "b", email: "b@b.com", bio: "")
        #expect(a.id != b.id)
    }

    @Test func equalUsersAreEqual() {
        let id = UUID()
        let u1 = User(id: id, username: "u", email: "e@e.com", bio: "bio")
        let u2 = User(id: id, username: "u", email: "e@e.com", bio: "bio")
        #expect(u1 == u2)
    }

    @Test func differentIdsMakeUsersUnequal() {
        let u1 = User(username: "u", email: "e@e.com", bio: "bio")
        let u2 = User(username: "u", email: "e@e.com", bio: "bio")
        #expect(u1 != u2)
    }
}

// MARK: - DomainError

@Suite("DomainError")
struct DomainErrorTests {
    @Test func staticCasesAreEqual() {
        #expect(DomainError.notFound == DomainError.notFound)
        #expect(DomainError.unauthorized == DomainError.unauthorized)
        #expect(DomainError.unknown == DomainError.unknown)
    }

    @Test func networkErrorMatchesByMessage() {
        #expect(DomainError.networkError("timeout") == DomainError.networkError("timeout"))
        #expect(DomainError.networkError("timeout") != DomainError.networkError("500"))
    }

    @Test func differentCasesAreNotEqual() {
        #expect(DomainError.notFound != DomainError.unauthorized)
        #expect(DomainError.unauthorized != DomainError.unknown)
    }
}

// MARK: - ProfileUseCaseImpl

@Suite("ProfileUseCaseImpl")
struct ProfileUseCaseImplTests {
    @Test func fetchesExistingUser() async throws {
        let repo = MockRepository()
        let id = UUID()
        repo.usersById[id] = User(id: id, username: "alice", email: "alice@example.com", bio: "Developer")
        let useCase = ProfileUseCaseImpl(repository: repo)

        let user = try await useCase.getUserProfile(id: id)

        #expect(user.username == "alice")
        #expect(user.id == id)
    }

    @Test func throwsNotFoundForMissingUser() async throws {
        let repo = MockRepository()
        let useCase = ProfileUseCaseImpl(repository: repo)

        await #expect(throws: DomainError.notFound) {
            try await useCase.getUserProfile(id: UUID())
        }
    }

    @Test func updatesAndReturnsUser() async throws {
        let repo = MockRepository()
        let id = UUID()
        repo.usersById[id] = User(id: id, username: "bob", email: "bob@example.com", bio: "Old bio")
        let useCase = ProfileUseCaseImpl(repository: repo)

        let updated = User(id: id, username: "bob_v2", email: "bob@example.com", bio: "New bio")
        let result = try await useCase.updateUserProfile(user: updated)

        #expect(result.username == "bob_v2")
        #expect(result.bio == "New bio")
    }

    @Test func propagatesRepositoryError() async throws {
        let repo = MockRepository()
        repo.errorToThrow = .networkError("connection refused")
        let useCase = ProfileUseCaseImpl(repository: repo)

        await #expect(throws: DomainError.networkError("connection refused")) {
            try await useCase.getUserProfile(id: UUID())
        }
    }
}
