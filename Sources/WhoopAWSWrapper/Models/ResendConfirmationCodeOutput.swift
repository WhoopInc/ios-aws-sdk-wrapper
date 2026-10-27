import Foundation

public struct ResendConfirmationCodeOutput {
    public let codeDeliveryDetails: CodeDeliveryDetails?

    public init(codeDeliveryDetails: CodeDeliveryDetails? = nil) {
        self.codeDeliveryDetails = codeDeliveryDetails
    }
}
