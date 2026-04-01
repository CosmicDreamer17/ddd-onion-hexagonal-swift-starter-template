import Foundation
import CoreDomain

@MainActor
public final class ProfileViewModel: ObservableObject {
    @Published public private(set) var user: User?
    @Published public private(set) var isLoading: Bool = false
    @Published public private(set) var error: Error?
    
    private let useCase: ProfileUseCase
    private let currentUserId: UUID
    
    public init(useCase: ProfileUseCase, currentUserId: UUID) {
        self.useCase = useCase
        self.currentUserId = currentUserId
    }
    
    public func fetchProfile() async {
        isLoading = true
        error = nil
        do {
            user = try await useCase.getUserProfile(id: currentUserId)
        } catch {
            self.error = error
        }
        isLoading = false
    }
    
    public func updateProfile(username: String, bio: String) async {
        guard let currentUser = user else { return }
        let updatedUser = User(id: currentUser.id, username: username, email: currentUser.email, bio: bio)
        
        isLoading = true
        error = nil
        do {
            user = try await useCase.updateUserProfile(user: updatedUser)
        } catch {
            self.error = error
        }
        isLoading = false
    }
}
