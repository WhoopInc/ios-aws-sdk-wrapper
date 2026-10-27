import Foundation

public struct GetUserOutput {
    public let username: String
    public let userAttributes: [UserAttribute]
    public let mfaOptions: [MFAOption]?
    public let preferredMfaSetting: String?
    public let userMFASettingList: [String]?

    public init(
        username: String,
        userAttributes: [UserAttribute],
        mfaOptions: [MFAOption]? = nil,
        preferredMfaSetting: String? = nil,
        userMFASettingList: [String]? = nil
    ) {
        self.username = username
        self.userAttributes = userAttributes
        self.mfaOptions = mfaOptions
        self.preferredMfaSetting = preferredMfaSetting
        self.userMFASettingList = userMFASettingList
    }
}
