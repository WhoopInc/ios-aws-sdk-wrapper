import Foundation

public enum WhoopCognitoError: Error, Equatable, Sendable {
    case notAuthorized(message: String?)
    case userNotConfirmed
    case userNotFound
    case tooManyRequests
    case invalidParameter
    case expiredCode
    case codeMismatch
    case internalError
    case unknown(typeName: String)
}
