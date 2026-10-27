import Foundation

public struct GetUserAttributeVerificationCodeInput {
    public let accessToken: String
    public let attributeName: String

    public init(accessToken: String, attributeName: String) {
        self.accessToken = accessToken
        self.attributeName = attributeName
    }
}
