import SwiftUI
import CoreDomain

public struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel
    @State private var isEditing = false
    @State private var editUsername = ""
    @State private var editBio = ""

    public init(viewModel: ProfileViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if let user = viewModel.user {
                    profileContent(user: user)
                } else if let error = viewModel.error {
                    errorView(error: error)
                }
            }
            .navigationTitle("Profile")
            .toolbar {
                if viewModel.user != nil {
                    Button(isEditing ? "Cancel" : "Edit") {
                        if isEditing {
                            isEditing = false
                        } else {
                            if let user = viewModel.user {
                                editUsername = user.username
                                editBio = user.bio
                            }
                            isEditing = true
                        }
                    }
                    .font(Theme.Typography.body)
                }
            }
        }
        .task {
            await viewModel.fetchProfile()
        }
    }

    @ViewBuilder
    private func profileContent(user: User) -> some View {
        if isEditing {
            editForm
        } else {
            displayProfile(user: user)
        }
    }

    private func displayProfile(user: User) -> some View {
        List {
            Section("Account") {
                LabeledContent("Username", value: user.username)
                LabeledContent("Email", value: user.email)
            }
            Section("About") {
                Text(user.bio)
                    .font(Theme.Typography.body)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var editForm: some View {
        Form {
            Section("Account") {
                TextField("Username", text: $editUsername)
                    .font(Theme.Typography.body)
            }
            Section("About") {
                TextField("Bio", text: $editBio, axis: .vertical)
                    .font(Theme.Typography.body)
                    .lineLimit(3...)
            }
            Section {
                Button("Save") {
                    Task {
                        await viewModel.updateProfile(username: editUsername, bio: editBio)
                        isEditing = false
                    }
                }
                .disabled(editUsername.isEmpty)
            }
        }
    }

    private func errorView(error: Error) -> some View {
        VStack(spacing: Theme.Spacing.medium) {
            Image(systemName: "exclamationmark.triangle")
                .font(Theme.Typography.title)
                .foregroundStyle(Theme.Colors.error)
            Text(error.localizedDescription)
                .font(Theme.Typography.caption)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            Button("Retry") {
                Task { await viewModel.fetchProfile() }
            }
            .buttonStyle(.bordered)
        }
        .padding(Theme.Spacing.large)
    }
}
