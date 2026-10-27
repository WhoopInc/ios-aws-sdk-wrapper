import AWSCognitoIdentityProvider
import Testing
@testable import WhoopAWSWrapper

struct WhoopCognitoClientTests {
    private let awsClient = MockCognitoIdentityProviderClient()
    private var client: WhoopCognitoClient { WhoopCognitoClient(awsClient: awsClient) }

    @Test func initiateAuthForwardsInputAndMapsOutput() async throws {
        awsClient.initiateAuthOutput = AWSCognitoIdentityProvider.InitiateAuthOutput(
            authenticationResult: AWSTypes.AuthenticationResultType(accessToken: "access", expiresIn: 3600, refreshToken: "refresh"),
            challengeName: .smsMfa,
            challengeParameters: ["CODE_DELIVERY_DESTINATION": "+1***"],
            session: "session"
        )

        let output = try await client.initiateAuth(input: WhoopAWSWrapper.InitiateAuthInput(
            authFlow: .userPasswordAuth,
            authParameters: ["USERNAME": "user"],
            clientId: "client"
        ))

        #expect(awsClient.initiateAuthInput?.authFlow == .userPasswordAuth)
        #expect(awsClient.initiateAuthInput?.authParameters == ["USERNAME": "user"])
        #expect(awsClient.initiateAuthInput?.clientId == "client")
        #expect(output.authenticationResult?.accessToken == "access")
        #expect(output.authenticationResult?.refreshToken == "refresh")
        #expect(output.authenticationResult?.expiresIn == 3600)
        #expect(output.challengeName == .smsMfa)
        #expect(output.session == "session")
        #expect(output.challengeParameters == ["CODE_DELIVERY_DESTINATION": "+1***"])
    }

    @Test func initiateAuthDropsResultWithoutRefreshToken() async throws {
        awsClient.initiateAuthOutput = AWSCognitoIdentityProvider.InitiateAuthOutput(
            authenticationResult: AWSTypes.AuthenticationResultType(accessToken: "access")
        )

        let output = try await client.initiateAuth(input: WhoopAWSWrapper.InitiateAuthInput(
            authFlow: .refreshTokenAuth,
            authParameters: [:],
            clientId: "client"
        ))

        #expect(output.authenticationResult == nil)
    }

    @Test func respondToAuthChallengeForwardsInputAndMapsOutput() async throws {
        awsClient.respondToAuthChallengeOutput = AWSCognitoIdentityProvider.RespondToAuthChallengeOutput(
            authenticationResult: AWSTypes.AuthenticationResultType(accessToken: "access", expiresIn: 60, refreshToken: "refresh")
        )

        let output = try await client.respondToAuthChallenge(input: WhoopAWSWrapper.RespondToAuthChallengeInput(
            challengeName: .softwareTokenMfa,
            challengeResponses: ["SOFTWARE_TOKEN_MFA_CODE": "123456"],
            clientId: "client",
            session: "session"
        ))

        #expect(awsClient.respondToAuthChallengeInput?.challengeName == .softwareTokenMfa)
        #expect(awsClient.respondToAuthChallengeInput?.challengeResponses == ["SOFTWARE_TOKEN_MFA_CODE": "123456"])
        #expect(awsClient.respondToAuthChallengeInput?.clientId == "client")
        #expect(awsClient.respondToAuthChallengeInput?.session == "session")
        #expect(output.authenticationResult?.accessToken == "access")
        #expect(output.challengeName == nil)
    }

    @Test func changePasswordForwardsInput() async throws {
        try await client.changePassword(input: WhoopAWSWrapper.ChangePasswordInput(
            accessToken: "access",
            previousPassword: "old",
            proposedPassword: "new"
        ))

        #expect(awsClient.changePasswordInput?.accessToken == "access")
        #expect(awsClient.changePasswordInput?.previousPassword == "old")
        #expect(awsClient.changePasswordInput?.proposedPassword == "new")
    }

    @Test func revokeTokenForwardsInput() async throws {
        try await client.revokeToken(input: WhoopAWSWrapper.RevokeTokenInput(clientId: "client", token: "refresh"))

        #expect(awsClient.revokeTokenInput?.clientId == "client")
        #expect(awsClient.revokeTokenInput?.token == "refresh")
    }

    @Test func updateUserAttributesForwardsInputAndMapsOutput() async throws {
        awsClient.updateUserAttributesOutput = AWSCognitoIdentityProvider.UpdateUserAttributesOutput(
            codeDeliveryDetailsList: [AWSTypes.CodeDeliveryDetailsType(attributeName: "email", deliveryMedium: .email, destination: "a***@whoop.com")]
        )

        let output = try await client.updateUserAttributes(input: WhoopAWSWrapper.UpdateUserAttributesInput(
            accessToken: "access",
            userAttributes: [UserAttribute(name: "email", value: "a@whoop.com")]
        ))

        #expect(awsClient.updateUserAttributesInput?.accessToken == "access")
        #expect(awsClient.updateUserAttributesInput?.userAttributes?.first?.name == "email")
        #expect(awsClient.updateUserAttributesInput?.userAttributes?.first?.value == "a@whoop.com")
        #expect(output.codeDeliveryDetailsList == [
            CodeDeliveryDetails(destination: "a***@whoop.com", deliveryMedium: "EMAIL", attributeName: "email")
        ])
    }

    @Test func resendConfirmationCodeForwardsInputAndMapsOutput() async throws {
        awsClient.resendConfirmationCodeOutput = AWSCognitoIdentityProvider.ResendConfirmationCodeOutput(
            codeDeliveryDetails: AWSTypes.CodeDeliveryDetailsType(attributeName: "phone_number", deliveryMedium: .sms, destination: "+1***")
        )

        let output = try await client.resendConfirmationCode(input: WhoopAWSWrapper.ResendConfirmationCodeInput(
            clientId: "client",
            username: "user"
        ))

        #expect(awsClient.resendConfirmationCodeInput?.clientId == "client")
        #expect(awsClient.resendConfirmationCodeInput?.username == "user")
        #expect(output.codeDeliveryDetails == CodeDeliveryDetails(destination: "+1***", deliveryMedium: "SMS", attributeName: "phone_number"))
    }

    @Test func getUserAttributeVerificationCodeForwardsInputAndMapsOutput() async throws {
        awsClient.getUserAttributeVerificationCodeOutput = AWSCognitoIdentityProvider.GetUserAttributeVerificationCodeOutput(
            codeDeliveryDetails: AWSTypes.CodeDeliveryDetailsType(attributeName: "email", deliveryMedium: .email, destination: "a***")
        )

        let output = try await client.getUserAttributeVerificationCode(input: WhoopAWSWrapper.GetUserAttributeVerificationCodeInput(
            accessToken: "access",
            attributeName: "email"
        ))

        #expect(awsClient.getUserAttributeVerificationCodeInput?.accessToken == "access")
        #expect(awsClient.getUserAttributeVerificationCodeInput?.attributeName == "email")
        #expect(output.codeDeliveryDetails == CodeDeliveryDetails(destination: "a***", deliveryMedium: "EMAIL", attributeName: "email"))
    }

    @Test func verifyUserAttributeForwardsInput() async throws {
        try await client.verifyUserAttribute(input: WhoopAWSWrapper.VerifyUserAttributeInput(
            accessToken: "access",
            attributeName: "email",
            code: "123456"
        ))

        #expect(awsClient.verifyUserAttributeInput?.accessToken == "access")
        #expect(awsClient.verifyUserAttributeInput?.attributeName == "email")
        #expect(awsClient.verifyUserAttributeInput?.code == "123456")
    }

    @Test func setUserMFAPreferenceForwardsSettings() async throws {
        try await client.setUserMFAPreference(input: WhoopAWSWrapper.SetUserMFAPreferenceInput(
            accessToken: "access",
            smsMfaSettings: MFASettings(enabled: true, preferredMfa: true),
            softwareTokenMfaSettings: MFASettings(enabled: true, preferredMfa: false)
        ))

        let input = try #require(awsClient.setUserMFAPreferenceInput)
        #expect(input.accessToken == "access")
        #expect(input.smsMfaSettings?.enabled == true)
        #expect(input.smsMfaSettings?.preferredMfa == true)
        #expect(input.softwareTokenMfaSettings?.enabled == true)
        #expect(input.softwareTokenMfaSettings?.preferredMfa == false)
    }

    @Test func getUserForwardsInputAndMapsOutput() async throws {
        awsClient.getUserOutput = AWSCognitoIdentityProvider.GetUserOutput(
            mfaOptions: [AWSTypes.MFAOptionType(attributeName: "phone_number", deliveryMedium: .sms)],
            preferredMfaSetting: "SMS_MFA",
            userAttributes: [AWSTypes.AttributeType(name: "email", value: "a@whoop.com")],
            userMFASettingList: ["SMS_MFA", "EMAIL_OTP"],
            username: "user"
        )

        let output = try await client.getUser(input: WhoopAWSWrapper.GetUserInput(accessToken: "access"))

        #expect(awsClient.getUserInput?.accessToken == "access")
        #expect(output.username == "user")
        #expect(output.userAttributes.map(\.name) == ["email"])
        #expect(output.userAttributes.map(\.value) == ["a@whoop.com"])
        #expect(output.mfaOptions == [MFAOption(deliveryMedium: "SMS", attributeName: "phone_number")])
        #expect(output.preferredMfaSetting == "SMS_MFA")
        #expect(output.userMFASettingList == ["SMS_MFA", "EMAIL_OTP"])
    }
}
