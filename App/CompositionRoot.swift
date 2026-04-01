import SwiftUI
import CoreDomain
import CoreData
import CoreUI

/// Assembles the dependency graph: infrastructure → use case → view model → view.
/// This is the only place in the app allowed to reference concrete infrastructure types.
@MainActor
final class CompositionRoot {
    static let shared = CompositionRoot()

    private let configuration: AppConfiguration = DefaultAppConfiguration.current

    // The current user ID would come from your auth layer in a real app.
    private let currentUserId = UUID(uuidString: "00000000-0000-0000-0000-000000000001") ?? UUID()

    /// Selects the repository implementation based on the active environment.
    /// Swap InMemoryProfileRepository for NetworkProfileRepository when your API is ready.
    private lazy var profileRepository: ProfileRepositoryPort = {
        switch configuration.environment {
        case .production, .staging:
            return NetworkProfileRepository(configuration: configuration)
        case .development:
            return InMemoryProfileRepository()
        }
    }()

    private lazy var profileUseCase: ProfileUseCase = ProfileUseCaseImpl(repository: profileRepository)

    func makeProfileViewModel() -> ProfileViewModel {
        ProfileViewModel(useCase: profileUseCase, currentUserId: currentUserId)
    }

    func makeProfileView() -> some View {
        ProfileView(viewModel: makeProfileViewModel())
    }
}
