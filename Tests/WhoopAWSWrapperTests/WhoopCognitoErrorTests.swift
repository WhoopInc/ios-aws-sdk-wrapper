import AWSCognitoIdentityProvider
import Testing
@testable import WhoopAWSWrapper

struct WhoopCognitoErrorTests {
    private struct NetworkError: Error {}

    static let mappedErrors: [(any Error, WhoopCognitoError)] = [
        (AWSCognitoIdentityProvider.NotAuthorizedException(message: "Password attempts exceeded"), .notAuthorized(message: "Password attempts exceeded")),
        (AWSCognitoIdentityProvider.UserNotConfirmedException(), .userNotConfirmed),
        (AWSCognitoIdentityProvider.UserNotFoundException(), .userNotFound),
        (AWSCognitoIdentityProvider.TooManyRequestsException(), .tooManyRequests),
        (AWSCognitoIdentityProvider.InvalidParameterException(), .invalidParameter),
        (AWSCognitoIdentityProvider.ExpiredCodeException(), .expiredCode),
        (AWSCognitoIdentityProvider.CodeMismatchException(), .codeMismatch),
        (AWSCognitoIdentityProvider.InternalErrorException(), .internalError),
        (AWSCognitoIdentityProvider.LimitExceededException(), .unknown(typeName: "LimitExceededException")),
    ]

    @Test(arguments: mappedErrors)
    func mapsAWSErrors(awsError: any Error, expected: WhoopCognitoError) async {
        let awsClient = MockCognitoIdentityProviderClient()
        awsClient.error = awsError
        let client = WhoopCognitoClient(awsClient: awsClient)

        await #expect(throws: expected) {
            try await client.revokeToken(input: WhoopAWSWrapper.RevokeTokenInput(clientId: "client", token: "token"))
        }
    }

    @Test func passesThroughNonAWSErrors() async {
        let awsClient = MockCognitoIdentityProviderClient()
        awsClient.error = NetworkError()
        let client = WhoopCognitoClient(awsClient: awsClient)

        await #expect(throws: NetworkError.self) {
            try await client.getUser(input: WhoopAWSWrapper.GetUserInput(accessToken: "access"))
        }
    }
}
