import Foundation

public protocol WhoopCognitoClientProtocol {
    var userPoolId: String { get }
    var clientId: String { get }

    func initiateAuth(input: InitiateAuthInput) async throws -> InitiateAuthOutput
    func respondToAuthChallenge(input: RespondToAuthChallengeInput) async throws -> RespondToAuthChallengeOutput
    func changePassword(input: ChangePasswordInput) async throws
    func revokeToken(input: RevokeTokenInput) async throws
    func updateUserAttributes(input: UpdateUserAttributesInput) async throws -> UpdateUserAttributesOutput
    func resendConfirmationCode(input: ResendConfirmationCodeInput) async throws -> ResendConfirmationCodeOutput
    func getUserAttributeVerificationCode(input: GetUserAttributeVerificationCodeInput) async throws -> GetUserAttributeVerificationCodeOutput
    func verifyUserAttribute(input: VerifyUserAttributeInput) async throws
    func setUserMFAPreference(input: SetUserMFAPreferenceInput) async throws
    func getUser(input: GetUserInput) async throws -> GetUserOutput
}
