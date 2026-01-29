import Foundation

/// Represents the challenge name type for Cognito MFA challenges
public enum ChallengeNameType: String {
    case smsMfa = "SMS_MFA"
    case emailOtp = "EMAIL_OTP"
    case softwareTokenMfa = "SOFTWARE_TOKEN_MFA"
}

