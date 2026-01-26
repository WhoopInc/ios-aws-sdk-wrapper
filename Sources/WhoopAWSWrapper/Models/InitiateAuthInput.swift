import Foundation

/// Input for initiating authentication with Cognito
public struct InitiateAuthInput {
    public let authFlow: AuthFlowType
    public let authParameters: [String: String]
    public let clientId: String
    
    public init(authFlow: AuthFlowType, authParameters: [String: String], clientId: String) {
        self.authFlow = authFlow
        self.authParameters = authParameters
        self.clientId = clientId
    }
}

