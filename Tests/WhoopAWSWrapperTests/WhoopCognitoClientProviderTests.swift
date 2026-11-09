import Foundation
import Testing
import WhoopAWSWrapper

struct WhoopCognitoClientProviderTests {
    @Test func missingServiceIdsFallBackToEmptyStrings() {
        let client = WhoopCognitoClientProvider.createClient(bundle: Bundle(for: BundleToken.self), endpoint: "https://example.com")

        #expect(client.userPoolId.isEmpty)
        #expect(client.clientId.isEmpty)
    }
}

private final class BundleToken {}
