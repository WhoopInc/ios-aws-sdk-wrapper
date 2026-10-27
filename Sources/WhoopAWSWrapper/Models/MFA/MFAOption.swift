import Foundation

public struct MFAOption: Equatable {
    public let deliveryMedium: String?
    public let attributeName: String?

    public init(deliveryMedium: String? = nil, attributeName: String? = nil) {
        self.deliveryMedium = deliveryMedium
        self.attributeName = attributeName
    }
}
