import Foundation

public struct ResendConfirmationCodeInput {
    public let clientId: String
    public let username: String

    public init(clientId: String, username: String) {
        self.clientId = clientId
        self.username = username
    }
}
