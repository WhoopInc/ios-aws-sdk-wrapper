import AWSCognitoIdentityProvider
@testable import WhoopAWSWrapper

final class MockCognitoIdentityProviderClient: CognitoIdentityProviderClientProtocol {
    var error: Error?

    var initiateAuthInput: AWSCognitoIdentityProvider.InitiateAuthInput?
    var initiateAuthOutput = AWSCognitoIdentityProvider.InitiateAuthOutput()

    var respondToAuthChallengeInput: AWSCognitoIdentityProvider.RespondToAuthChallengeInput?
    var respondToAuthChallengeOutput = AWSCognitoIdentityProvider.RespondToAuthChallengeOutput()

    var changePasswordInput: AWSCognitoIdentityProvider.ChangePasswordInput?
    var revokeTokenInput: AWSCognitoIdentityProvider.RevokeTokenInput?

    var updateUserAttributesInput: AWSCognitoIdentityProvider.UpdateUserAttributesInput?
    var updateUserAttributesOutput = AWSCognitoIdentityProvider.UpdateUserAttributesOutput()

    var resendConfirmationCodeInput: AWSCognitoIdentityProvider.ResendConfirmationCodeInput?
    var resendConfirmationCodeOutput = AWSCognitoIdentityProvider.ResendConfirmationCodeOutput()

    var getUserAttributeVerificationCodeInput: AWSCognitoIdentityProvider.GetUserAttributeVerificationCodeInput?
    var getUserAttributeVerificationCodeOutput = AWSCognitoIdentityProvider.GetUserAttributeVerificationCodeOutput()

    var verifyUserAttributeInput: AWSCognitoIdentityProvider.VerifyUserAttributeInput?
    var setUserMFAPreferenceInput: AWSCognitoIdentityProvider.SetUserMFAPreferenceInput?

    var getUserInput: AWSCognitoIdentityProvider.GetUserInput?
    var getUserOutput = AWSCognitoIdentityProvider.GetUserOutput()

    func initiateAuth(input: AWSCognitoIdentityProvider.InitiateAuthInput) async throws -> AWSCognitoIdentityProvider.InitiateAuthOutput {
        initiateAuthInput = input
        try throwIfNeeded()
        return initiateAuthOutput
    }

    func respondToAuthChallenge(input: AWSCognitoIdentityProvider.RespondToAuthChallengeInput) async throws -> AWSCognitoIdentityProvider.RespondToAuthChallengeOutput {
        respondToAuthChallengeInput = input
        try throwIfNeeded()
        return respondToAuthChallengeOutput
    }

    func changePassword(input: AWSCognitoIdentityProvider.ChangePasswordInput) async throws -> AWSCognitoIdentityProvider.ChangePasswordOutput {
        changePasswordInput = input
        try throwIfNeeded()
        return AWSCognitoIdentityProvider.ChangePasswordOutput()
    }

    func revokeToken(input: AWSCognitoIdentityProvider.RevokeTokenInput) async throws -> AWSCognitoIdentityProvider.RevokeTokenOutput {
        revokeTokenInput = input
        try throwIfNeeded()
        return AWSCognitoIdentityProvider.RevokeTokenOutput()
    }

    func updateUserAttributes(input: AWSCognitoIdentityProvider.UpdateUserAttributesInput) async throws -> AWSCognitoIdentityProvider.UpdateUserAttributesOutput {
        updateUserAttributesInput = input
        try throwIfNeeded()
        return updateUserAttributesOutput
    }

    func resendConfirmationCode(input: AWSCognitoIdentityProvider.ResendConfirmationCodeInput) async throws -> AWSCognitoIdentityProvider.ResendConfirmationCodeOutput {
        resendConfirmationCodeInput = input
        try throwIfNeeded()
        return resendConfirmationCodeOutput
    }

    func getUserAttributeVerificationCode(input: AWSCognitoIdentityProvider.GetUserAttributeVerificationCodeInput) async throws -> AWSCognitoIdentityProvider.GetUserAttributeVerificationCodeOutput {
        getUserAttributeVerificationCodeInput = input
        try throwIfNeeded()
        return getUserAttributeVerificationCodeOutput
    }

    func verifyUserAttribute(input: AWSCognitoIdentityProvider.VerifyUserAttributeInput) async throws -> AWSCognitoIdentityProvider.VerifyUserAttributeOutput {
        verifyUserAttributeInput = input
        try throwIfNeeded()
        return AWSCognitoIdentityProvider.VerifyUserAttributeOutput()
    }

    func setUserMFAPreference(input: AWSCognitoIdentityProvider.SetUserMFAPreferenceInput) async throws -> AWSCognitoIdentityProvider.SetUserMFAPreferenceOutput {
        setUserMFAPreferenceInput = input
        try throwIfNeeded()
        return AWSCognitoIdentityProvider.SetUserMFAPreferenceOutput()
    }

    func getUser(input: AWSCognitoIdentityProvider.GetUserInput) async throws -> AWSCognitoIdentityProvider.GetUserOutput {
        getUserInput = input
        try throwIfNeeded()
        return getUserOutput
    }

    private func throwIfNeeded() throws {
        if let error {
            throw error
        }
    }
}
