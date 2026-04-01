import Testing
import Foundation
@testable import CoreUI
import CoreDomain

// MARK: - Test double

private final class StubProfileUseCase: ProfileUseCase {
    var userToReturn: User?
    var errorToThrow: DomainError?
    var updatedUserToReturn: User?

    func getUserProfile(id: UUID) async throws -> User {
        if let error = errorToThrow { throw error }
        return userToReturn ?? User(id: id, username: "stub", email: "stub@test.com", bio: "stub")
    }

    func updateUserProfile(user: User) async throws -> User {
        if let error = errorToThrow { throw error }
        return updatedUserToReturn ?? user
    }
}

// MARK: - ProfileViewModel

@Suite("ProfileViewModel")
struct ProfileViewModelTests {
    private let userId = UUID()

    @Test @MainActor func fetchProfileSetsUser() async {
        let stub = StubProfileUseCase()
        stub.userToReturn = User(id: userId, username: "alice", email: "alice@test.com", bio: "dev")
        let vm = ProfileViewModel(useCase: stub, currentUserId: userId)

        await vm.fetchProfile()

        #expect(vm.user?.username == "alice")
        #expect(vm.isLoading == false)
        #expect(vm.error == nil)
    }

    @Test @MainActor func fetchProfileSetsErrorOnFailure() async {
        let stub = StubProfileUseCase()
        stub.errorToThrow = .notFound
        let vm = ProfileViewModel(useCase: stub, currentUserId: userId)

        await vm.fetchProfile()

        #expect(vm.user == nil)
        #expect(vm.error != nil)
        #expect(vm.isLoading == false)
    }

    @Test @MainActor func updateProfileUpdatesUser() async {
        let stub = StubProfileUseCase()
        let original = User(id: userId, username: "bob", email: "bob@test.com", bio: "old bio")
        stub.userToReturn = original
        let vm = ProfileViewModel(useCase: stub, currentUserId: userId)
        await vm.fetchProfile()

        let updated = User(id: userId, username: "bob_new", email: "bob@test.com", bio: "new bio")
        stub.updatedUserToReturn = updated
        await vm.updateProfile(username: "bob_new", bio: "new bio")

        #expect(vm.user?.username == "bob_new")
        #expect(vm.user?.bio == "new bio")
        #expect(vm.isLoading == false)
    }

    @Test @MainActor func updateProfileSetsErrorOnFailure() async {
        let stub = StubProfileUseCase()
        let original = User(id: userId, username: "carol", email: "carol@test.com", bio: "bio")
        stub.userToReturn = original
        let vm = ProfileViewModel(useCase: stub, currentUserId: userId)
        await vm.fetchProfile()

        stub.errorToThrow = .networkError("save failed")
        await vm.updateProfile(username: "carol_new", bio: "new bio")

        #expect(vm.error != nil)
        #expect(vm.isLoading == false)
    }

    @Test @MainActor func updateProfileIsNoOpWhenUserIsNil() async {
        let stub = StubProfileUseCase()
        let vm = ProfileViewModel(useCase: stub, currentUserId: userId)

        await vm.updateProfile(username: "new", bio: "new")

        #expect(vm.user == nil)
    }
}
