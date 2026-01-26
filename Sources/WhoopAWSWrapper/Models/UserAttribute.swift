import Foundation

/// Represents a user attribute for Cognito
public struct UserAttribute {
    public let name: String
    public let value: String
    
    public init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}

