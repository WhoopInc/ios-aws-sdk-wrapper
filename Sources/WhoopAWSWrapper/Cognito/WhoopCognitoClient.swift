internal import AWSCognitoIdentityProvider
import Foundation

typealias AWSTypes = AWSCognitoIdentityProvider.CognitoIdentityProviderClientTypes

final class WhoopCognitoClient: WhoopCognitoClientProtocol {
    private let region: String
    private let endpoint: String
    private let urlSession: URLSession?
    private var cachedAWSClient: CognitoIdentityProviderClientProtocol?

    let userPoolId: String
    let clientId: String

    init(
        userPoolId: String,
        clientId: String,
        region: String = "us-west-2",
        endpoint: String,
        urlSession: URLSession? = nil
    ) {
        self.userPoolId = userPoolId
        self.clientId = clientId
        self.region = region
        self.endpoint = endpoint
        self.urlSession = urlSession
    }

    convenience init(
        userPoolId: String = "",
        clientId: String = "",
        region: String = "us-west-2",
        endpoint: String = "",
        awsClient: CognitoIdentityProviderClientProtocol
    ) {
        self.init(userPoolId: userPoolId, clientId: clientId, region: region, endpoint: endpoint)
        self.cachedAWSClient = awsClient
    }

    func initiateAuth(input: InitiateAuthInput) async throws -> InitiateAuthOutput {
        let output = try await perform { client in
            try await client.initiateAuth(input: AWSCognitoIdentityProvider.InitiateAuthInput(
                authFlow: awsAuthFlow(input.authFlow),
                authParameters: input.authParameters,
                clientId: input.clientId
            ))
        }

        return InitiateAuthOutput(
            authenticationResult: authenticationResult(output.authenticationResult),
            challengeName: challengeName(output.challengeName),
            session: output.session,
            challengeParameters: output.challengeParameters
        )
    }

    func respondToAuthChallenge(input: RespondToAuthChallengeInput) async throws -> RespondToAuthChallengeOutput {
        let output = try await perform { client in
            try await client.respondToAuthChallenge(input: AWSCognitoIdentityProvider.RespondToAuthChallengeInput(
                challengeName: awsChallengeName(input.challengeName),
                challengeResponses: input.challengeResponses,
                clientId: input.clientId,
                session: input.session
            ))
        }

        return RespondToAuthChallengeOutput(
            authenticationResult: authenticationResult(output.authenticationResult),
            challengeName: challengeName(output.challengeName)
        )
    }

    func changePassword(input: ChangePasswordInput) async throws {
        _ = try await perform { client in
            try await client.changePassword(input: AWSCognitoIdentityProvider.ChangePasswordInput(
                accessToken: input.accessToken,
                previousPassword: input.previousPassword,
                proposedPassword: input.proposedPassword
            ))
        }
    }

    func revokeToken(input: RevokeTokenInput) async throws {
        _ = try await perform { client in
            try await client.revokeToken(input: AWSCognitoIdentityProvider.RevokeTokenInput(
                clientId: input.clientId,
                token: input.token
            ))
        }
    }

    func updateUserAttributes(input: UpdateUserAttributesInput) async throws -> UpdateUserAttributesOutput {
        let output = try await perform { client in
            try await client.updateUserAttributes(input: AWSCognitoIdentityProvider.UpdateUserAttributesInput(
                accessToken: input.accessToken,
                userAttributes: input.userAttributes.map { AWSTypes.AttributeType(name: $0.name, value: $0.value) }
            ))
        }

        return UpdateUserAttributesOutput(
            codeDeliveryDetailsList: output.codeDeliveryDetailsList?.map(codeDeliveryDetails)
        )
    }

    func resendConfirmationCode(input: ResendConfirmationCodeInput) async throws -> ResendConfirmationCodeOutput {
        let output = try await perform { client in
            try await client.resendConfirmationCode(input: AWSCognitoIdentityProvider.ResendConfirmationCodeInput(
                clientId: input.clientId,
                username: input.username
            ))
        }

        return ResendConfirmationCodeOutput(
            codeDeliveryDetails: output.codeDeliveryDetails.map(codeDeliveryDetails)
        )
    }

    func getUserAttributeVerificationCode(input: GetUserAttributeVerificationCodeInput) async throws -> GetUserAttributeVerificationCodeOutput {
        let output = try await perform { client in
            try await client.getUserAttributeVerificationCode(input: AWSCognitoIdentityProvider.GetUserAttributeVerificationCodeInput(
                accessToken: input.accessToken,
                attributeName: input.attributeName
            ))
        }

        return GetUserAttributeVerificationCodeOutput(
            codeDeliveryDetails: output.codeDeliveryDetails.map(codeDeliveryDetails)
        )
    }

    func verifyUserAttribute(input: VerifyUserAttributeInput) async throws {
        _ = try await perform { client in
            try await client.verifyUserAttribute(input: AWSCognitoIdentityProvider.VerifyUserAttributeInput(
                accessToken: input.accessToken,
                attributeName: input.attributeName,
                code: input.code
            ))
        }
    }

    func setUserMFAPreference(input: SetUserMFAPreferenceInput) async throws {
        _ = try await perform { client in
            try await client.setUserMFAPreference(input: AWSCognitoIdentityProvider.SetUserMFAPreferenceInput(
                accessToken: input.accessToken,
                smsMfaSettings: input.smsMfaSettings.map {
                    AWSTypes.SMSMfaSettingsType(enabled: $0.enabled, preferredMfa: $0.preferredMfa)
                },
                softwareTokenMfaSettings: input.softwareTokenMfaSettings.map {
                    AWSTypes.SoftwareTokenMfaSettingsType(enabled: $0.enabled, preferredMfa: $0.preferredMfa)
                }
            ))
        }
    }

    func getUser(input: GetUserInput) async throws -> GetUserOutput {
        let output = try await perform { client in
            try await client.getUser(input: AWSCognitoIdentityProvider.GetUserInput(accessToken: input.accessToken))
        }

        return GetUserOutput(
            username: output.username ?? "",
            userAttributes: (output.userAttributes ?? []).map { UserAttribute(name: $0.name ?? "", value: $0.value ?? "") },
            mfaOptions: output.mfaOptions?.map { MFAOption(deliveryMedium: $0.deliveryMedium?.rawValue, attributeName: $0.attributeName) },
            preferredMfaSetting: output.preferredMfaSetting,
            userMFASettingList: output.userMFASettingList
        )
    }

    private func perform<Output>(
        _ operation: (CognitoIdentityProviderClientProtocol) async throws -> Output
    ) async throws -> Output {
        let client = try awsClient()
        do {
            return try await operation(client)
        } catch {
            if let cognitoError = WhoopCognitoError(awsError: error) {
                throw cognitoError
            }
            throw error
        }
    }

    private func awsClient() throws -> CognitoIdentityProviderClientProtocol {
        if let cachedAWSClient {
            return cachedAWSClient
        }

        let httpClient = urlSession.map { URLSessionHTTPClient(urlSession: $0) }
        let client = try CognitoProvider(httpClient: httpClient).createClient(region: region, endpoint: endpoint)
        cachedAWSClient = client
        return client
    }

    private func awsAuthFlow(_ authFlow: AuthFlowType) -> AWSTypes.AuthFlowType {
        switch authFlow {
        case .refreshTokenAuth: .refreshTokenAuth
        case .userPasswordAuth: .userPasswordAuth
        }
    }

    private func awsChallengeName(_ challengeName: ChallengeNameType) -> AWSTypes.ChallengeNameType {
        switch challengeName {
        case .smsMfa: .smsMfa
        case .emailOtp: .emailOtp
        case .softwareTokenMfa: .softwareTokenMfa
        }
    }

    private func challengeName(_ challengeName: AWSTypes.ChallengeNameType?) -> ChallengeNameType? {
        switch challengeName {
        case .smsMfa: .smsMfa
        case .emailOtp: .emailOtp
        case .softwareTokenMfa: .softwareTokenMfa
        default: nil
        }
    }

    private func authenticationResult(_ result: AWSTypes.AuthenticationResultType?) -> AuthenticationResult? {
        guard let result, let accessToken = result.accessToken, let refreshToken = result.refreshToken else {
            return nil
        }
        return AuthenticationResult(accessToken: accessToken, refreshToken: refreshToken, expiresIn: result.expiresIn)
    }

    private func codeDeliveryDetails(_ details: AWSTypes.CodeDeliveryDetailsType) -> CodeDeliveryDetails {
        CodeDeliveryDetails(
            destination: details.destination,
            deliveryMedium: details.deliveryMedium?.rawValue,
            attributeName: details.attributeName
        )
    }
}
