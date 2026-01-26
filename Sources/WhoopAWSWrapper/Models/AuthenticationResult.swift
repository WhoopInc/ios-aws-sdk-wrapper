import Foundation

/// Represents the authentication result from Cognito
public struct AuthenticationResult {
    public let accessToken: String
    public let refreshToken: String
    public let expiresIn: Int
    
    public init(accessToken: String, refreshToken: String, expiresIn: Int) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiresIn = expiresIn
    }
}

