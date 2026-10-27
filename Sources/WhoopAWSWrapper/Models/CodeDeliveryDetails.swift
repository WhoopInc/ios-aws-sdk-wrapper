import Foundation

public struct CodeDeliveryDetails: Equatable {
    public let destination: String?
    public let deliveryMedium: String?
    public let attributeName: String?

    public init(destination: String? = nil, deliveryMedium: String? = nil, attributeName: String? = nil) {
        self.destination = destination
        self.deliveryMedium = deliveryMedium
        self.attributeName = attributeName
    }
}
