import Foundation

/// Represents the authentication flow type for Cognito
public enum AuthFlowType: String {
    case refreshTokenAuth = "REFRESH_TOKEN_AUTH"
    case userPasswordAuth = "USER_PASSWORD_AUTH"
}

