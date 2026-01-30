import Foundation

/// Input for changing a user's password
public struct ChangePasswordInput {
    public let accessToken: String
    public let previousPassword: String
    public let proposedPassword: String
    
    public init(accessToken: String, previousPassword: String, proposedPassword: String) {
        self.accessToken = accessToken
        self.previousPassword = previousPassword
        self.proposedPassword = proposedPassword
    }
}

