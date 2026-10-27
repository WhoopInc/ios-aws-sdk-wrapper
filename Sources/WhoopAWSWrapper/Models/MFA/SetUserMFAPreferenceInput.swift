import Foundation

public struct SetUserMFAPreferenceInput {
    public let accessToken: String
    public let smsMfaSettings: MFASettings?
    public let softwareTokenMfaSettings: MFASettings?

    public init(
        accessToken: String,
        smsMfaSettings: MFASettings? = nil,
        softwareTokenMfaSettings: MFASettings? = nil
    ) {
        self.accessToken = accessToken
        self.smsMfaSettings = smsMfaSettings
        self.softwareTokenMfaSettings = softwareTokenMfaSettings
    }
}
