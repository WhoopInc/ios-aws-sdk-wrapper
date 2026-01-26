import Foundation

/// Input for responding to an authentication challenge
public struct RespondToAuthChallengeInput {
    public let challengeName: ChallengeNameType
    public let challengeResponses: [String: String]
    public let clientId: String
    public let session: String
    
    public init(
        challengeName: ChallengeNameType,
        challengeResponses: [String: String],
        clientId: String,
        session: String
    ) {
        self.challengeName = challengeName
        self.challengeResponses = challengeResponses
        self.clientId = clientId
        self.session = session
    }
}

