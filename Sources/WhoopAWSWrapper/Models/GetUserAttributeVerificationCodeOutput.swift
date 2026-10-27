import Foundation

public struct GetUserAttributeVerificationCodeOutput {
    public let codeDeliveryDetails: CodeDeliveryDetails?

    public init(codeDeliveryDetails: CodeDeliveryDetails? = nil) {
        self.codeDeliveryDetails = codeDeliveryDetails
    }
}
