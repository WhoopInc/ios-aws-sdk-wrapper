import Foundation

/// Output from initiating authentication with Cognito
public struct InitiateAuthOutput {
    public let authenticationResult: AuthenticationResult?
    public let challengeName: ChallengeNameType?
    public let session: String?
    public let challengeParameters: [String: String]?
    
    public init(
        authenticationResult: AuthenticationResult?,
        challengeName: ChallengeNameType?,
        session: String?,
        challengeParameters: [String: String]?
    ) {
        self.authenticationResult = authenticationResult
        self.challengeName = challengeName
        self.session = session
        self.challengeParameters = challengeParameters
    }
}

