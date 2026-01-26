import Foundation

/// Input for revoking a token
public struct RevokeTokenInput {
    public let clientId: String
    public let token: String
    
    public init(clientId: String, token: String) {
        self.clientId = clientId
        self.token = token
    }
}

