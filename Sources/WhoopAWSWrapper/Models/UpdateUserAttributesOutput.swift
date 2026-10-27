import Foundation

public struct UpdateUserAttributesOutput {
    public let codeDeliveryDetailsList: [CodeDeliveryDetails]?

    public init(codeDeliveryDetailsList: [CodeDeliveryDetails]? = nil) {
        self.codeDeliveryDetailsList = codeDeliveryDetailsList
    }
}
