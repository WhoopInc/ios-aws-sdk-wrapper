import Foundation

public struct MFASettings {
    public let enabled: Bool
    public let preferredMfa: Bool

    public init(enabled: Bool, preferredMfa: Bool) {
        self.enabled = enabled
        self.preferredMfa = preferredMfa
    }
}
