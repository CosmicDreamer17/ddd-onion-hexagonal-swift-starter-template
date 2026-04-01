import Foundation

public struct User: Identifiable, Equatable, Codable {
    public let id: UUID
    public let username: String
    public let email: String
    public let bio: String
    
    public init(id: UUID = UUID(), username: String, email: String, bio: String) {
        self.id = id
        self.username = username
        self.email = email
        self.bio = bio
    }
}
