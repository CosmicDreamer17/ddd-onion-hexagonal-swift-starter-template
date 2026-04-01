import Testing
import Foundation
@testable import CoreData
import CoreDomain

@Suite("InMemoryProfileRepository")
struct InMemoryProfileRepositoryTests {
    private let seededId = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!

    @Test func returnsSeededUserById() async throws {
        let repo = InMemoryProfileRepository()
        let user = try await repo.fetchUser(id: seededId)
        #expect(user.id == seededId)
        #expect(user.username == "agent_smith")
        #expect(user.email == "smith@matrix.com")
    }

    @Test func throwsNotFoundForUnknownId() async throws {
        let repo = InMemoryProfileRepository()
        await #expect(throws: DomainError.notFound) {
            try await repo.fetchUser(id: UUID())
        }
    }

    @Test func savesAndFetchesNewUser() async throws {
        let repo = InMemoryProfileRepository()
        let id = UUID()
        let user = User(id: id, username: "neo", email: "neo@matrix.com", bio: "The One")

        let saved = try await repo.saveUser(user)
        #expect(saved.id == id)
        #expect(saved.username == "neo")

        let fetched = try await repo.fetchUser(id: id)
        #expect(fetched.username == "neo")
    }

    @Test func saveOverwritesExistingUser() async throws {
        let repo = InMemoryProfileRepository()
        let updated = User(id: seededId, username: "agent_smith_v2", email: "smith@matrix.com", bio: "Upgraded")

        _ = try await repo.saveUser(updated)
        let fetched = try await repo.fetchUser(id: seededId)

        #expect(fetched.username == "agent_smith_v2")
        #expect(fetched.bio == "Upgraded")
    }
}
