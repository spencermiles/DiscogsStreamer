import Combine
import Foundation

enum HTTPStatusError: Error {
    case nonHTTPResponse(URLResponse)
    case unacceptableStatusCode(Int)
}

extension Publisher where Output == URLSession.DataTaskPublisher.Output {
    func httpSuccess() -> AnyPublisher<(Data, HTTPURLResponse), Error> {
        httpStatusCode(200 ..< 300)
    }

    func httpStatusCode(_ acceptable: Int) -> AnyPublisher<(Data, HTTPURLResponse), Error> {
        httpStatusCode({ $0 == acceptable })
    }

    func httpStatusCode(_ acceptableRange: Range<Int>) -> AnyPublisher<(Data, HTTPURLResponse), Error> {
        httpStatusCode(acceptableRange.contains)
    }

    func httpStatusCode(_ isAcceptableStatus: @escaping (Int) -> Bool) -> AnyPublisher<(Data, HTTPURLResponse), Error> {
        tryMap { (data, urlResponse) in
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                throw HTTPStatusError.nonHTTPResponse(urlResponse)
            }

            guard isAcceptableStatus(httpResponse.statusCode) else {
                throw HTTPStatusError.unacceptableStatusCode(httpResponse.statusCode)
            }

            return (data, httpResponse)
        }
        .eraseToAnyPublisher()
    }
}
