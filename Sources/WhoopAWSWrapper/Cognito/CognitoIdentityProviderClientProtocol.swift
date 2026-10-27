internal import AWSCognitoIdentityProvider

internal protocol CognitoIdentityProviderClientProtocol {
    func initiateAuth(input: AWSCognitoIdentityProvider.InitiateAuthInput) async throws -> AWSCognitoIdentityProvider.InitiateAuthOutput
    func revokeToken(input: AWSCognitoIdentityProvider.RevokeTokenInput) async throws -> AWSCognitoIdentityProvider.RevokeTokenOutput
    func updateUserAttributes(input: AWSCognitoIdentityProvider.UpdateUserAttributesInput) async throws -> AWSCognitoIdentityProvider.UpdateUserAttributesOutput
    func changePassword(input: AWSCognitoIdentityProvider.ChangePasswordInput) async throws -> AWSCognitoIdentityProvider.ChangePasswordOutput
    func respondToAuthChallenge(input: AWSCognitoIdentityProvider.RespondToAuthChallengeInput) async throws -> AWSCognitoIdentityProvider.RespondToAuthChallengeOutput
    func getUser(input: AWSCognitoIdentityProvider.GetUserInput) async throws -> AWSCognitoIdentityProvider.GetUserOutput
    func resendConfirmationCode(input: AWSCognitoIdentityProvider.ResendConfirmationCodeInput) async throws -> AWSCognitoIdentityProvider.ResendConfirmationCodeOutput
    func setUserMFAPreference(input: AWSCognitoIdentityProvider.SetUserMFAPreferenceInput) async throws -> AWSCognitoIdentityProvider.SetUserMFAPreferenceOutput
    func verifyUserAttribute(input: AWSCognitoIdentityProvider.VerifyUserAttributeInput) async throws -> AWSCognitoIdentityProvider.VerifyUserAttributeOutput
    func getUserAttributeVerificationCode(input: AWSCognitoIdentityProvider.GetUserAttributeVerificationCodeInput) async throws -> AWSCognitoIdentityProvider.GetUserAttributeVerificationCodeOutput
}

extension AWSCognitoIdentityProvider.CognitoIdentityProviderClient: CognitoIdentityProviderClientProtocol {}
