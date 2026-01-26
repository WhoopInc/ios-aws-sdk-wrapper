import Foundation

/// Input for updating user attributes
public struct UpdateUserAttributesInput {
    public let accessToken: String
    public let userAttributes: [UserAttribute]
    
    public init(accessToken: String, userAttributes: [UserAttribute]) {
        self.accessToken = accessToken
        self.userAttributes = userAttributes
    }
}

