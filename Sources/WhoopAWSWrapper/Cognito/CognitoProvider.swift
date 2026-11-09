internal import AWSCognitoIdentityProvider
internal import ClientRuntime
import Foundation
internal import SmithyHTTPAPI
internal import SmithyRetries
internal import SmithyRetriesAPI

struct CognitoProvider {
    private let httpClient: SmithyHTTPAPI.HTTPClient?

    init(httpClient: SmithyHTTPAPI.HTTPClient? = nil) {
        self.httpClient = httpClient
    }

    func createClient(region: String, endpoint: String) throws -> CognitoIdentityProviderClientProtocol {
        let config = try AWSCognitoIdentityProvider.CognitoIdentityProviderClient.CognitoIdentityProviderClientConfiguration(
            region: region,
            retryStrategyOptions: SmithyRetriesAPI.RetryStrategyOptions(
                backoffStrategy: ExponentialBackoffStrategy(),
                maxRetriesBase: 1
            ),
            endpoint: endpoint
        )

        if let httpClient {
            config.httpClientEngine = httpClient
        }

        return AWSCognitoIdentityProvider.CognitoIdentityProviderClient(config: config)
    }
}
