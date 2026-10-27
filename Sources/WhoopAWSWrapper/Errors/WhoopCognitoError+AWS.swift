internal import AWSClientRuntime
internal import AWSCognitoIdentityProvider

extension WhoopCognitoError {
    init?(awsError error: Error) {
        switch error {
        case let error as AWSCognitoIdentityProvider.NotAuthorizedException:
            self = .notAuthorized(message: error.properties.message)
        case is AWSCognitoIdentityProvider.UserNotConfirmedException:
            self = .userNotConfirmed
        case is AWSCognitoIdentityProvider.UserNotFoundException:
            self = .userNotFound
        case is AWSCognitoIdentityProvider.TooManyRequestsException:
            self = .tooManyRequests
        case is AWSCognitoIdentityProvider.InvalidParameterException:
            self = .invalidParameter
        case is AWSCognitoIdentityProvider.ExpiredCodeException:
            self = .expiredCode
        case is AWSCognitoIdentityProvider.CodeMismatchException:
            self = .codeMismatch
        case is AWSCognitoIdentityProvider.InternalErrorException:
            self = .internalError
        case let error as AWSServiceError:
            self = .unknown(typeName: String(describing: type(of: error)))
        default:
            return nil
        }
    }
}
