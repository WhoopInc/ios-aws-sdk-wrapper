import Foundation

public enum WhoopCognitoClientProvider {
    public static func createClient(
        bundle: Bundle = .main,
        endpoint: String,
        region: String = "us-west-2",
        urlSession: URLSession? = nil
    ) -> WhoopCognitoClientProtocol {
        WhoopCognitoClient(
            userPoolId: serviceId(for: "AwsCognitoUserPool", in: bundle),
            clientId: serviceId(for: "AwsCognitoClient", in: bundle),
            region: region,
            endpoint: endpoint,
            urlSession: urlSession
        )
    }

    private static func serviceId(for key: String, in bundle: Bundle) -> String {
        let serviceIds = bundle.object(forInfoDictionaryKey: "Service Ids") as? [String: Any]
        return serviceIds?[key] as? String ?? ""
    }
}
