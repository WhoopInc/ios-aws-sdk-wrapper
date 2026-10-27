import Foundation

public struct VerifyUserAttributeInput {
    public let accessToken: String
    public let attributeName: String
    public let code: String

    public init(accessToken: String, attributeName: String, code: String) {
        self.accessToken = accessToken
        self.attributeName = attributeName
        self.code = code
    }
}
