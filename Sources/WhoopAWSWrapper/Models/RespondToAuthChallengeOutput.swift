import Foundation

/// Output from responding to an authentication challenge
public struct RespondToAuthChallengeOutput {
    public let authenticationResult: AuthenticationResult?
    public let challengeName: ChallengeNameType?
    
    public init(authenticationResult: AuthenticationResult?, challengeName: ChallengeNameType?) {
        self.authenticationResult = authenticationResult
        self.challengeName = challengeName
    }
}

