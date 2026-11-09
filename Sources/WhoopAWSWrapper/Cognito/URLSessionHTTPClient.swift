internal import ClientRuntime
import Foundation
internal import Smithy
internal import SmithyHTTPAPI

final class URLSessionHTTPClient: SmithyHTTPAPI.HTTPClient {
    private let urlSession: URLSession

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    func send(request: SmithyHTTPAPI.HTTPRequest) async throws -> SmithyHTTPAPI.HTTPResponse {
        guard let url = request.endpoint.url else {
            throw HTTPClientError.pathCreationFailed("Failed to create URL from endpoint")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue

        if case .data(let data) = request.body {
            urlRequest.httpBody = data
        }

        for header in request.headers.headers {
            urlRequest.setValue(header.value.joined(separator: ", "), forHTTPHeaderField: header.name)
        }

        let (data, response) = try await urlSession.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw HTTPClientError.unknownError("Response was not HTTPURLResponse")
        }

        return smithyResponse(data: data, httpResponse: httpResponse)
    }

    private func smithyResponse(data: Data, httpResponse: HTTPURLResponse) -> SmithyHTTPAPI.HTTPResponse {
        var headers = Headers()
        for (key, value) in httpResponse.allHeaderFields {
            if let key = key as? String, let value = value as? String {
                headers.add(name: key, value: value)
            }
        }

        return SmithyHTTPAPI.HTTPResponse(
            headers: headers,
            body: ByteStream.data(data),
            statusCode: SmithyHTTPAPI.HTTPStatusCode(rawValue: httpResponse.statusCode) ?? .ok
        )
    }
}

enum HTTPClientError: Error {
    case pathCreationFailed(String)
    case unknownError(String)
}
