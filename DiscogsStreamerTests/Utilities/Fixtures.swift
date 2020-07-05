import Foundation
import XCTest

private class FixtureURLProtocol: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool {
        request.url?.scheme == "fixture"
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    enum FixtureURLError: Error {
        case missingBundleID(URL)
        case missingBundle(identifier: String)
        case missingResourcePath(URL)
        case missingResource(Bundle, name: String, subdirectory: [String])
    }

    override func startLoading() {
        do {
            let (response, content) = try loadFixture(for: request.url!)

            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: content)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    private func loadFixture(for url: URL) throws -> (URLResponse, Data) {
        guard let bundleID = url.host else {
            throw FixtureURLError.missingBundleID(url)
        }

        let path = url.pathComponents.dropFirst() // first element is `/`

//        guard let resource = path.last else {
//            throw FixtureURLError.missingResourcePath(url)
//        }

        guard let bundle = Bundle(identifier: bundleID) else {
            throw FixtureURLError.missingBundle(identifier: bundleID)
        }

        let subdirectory = ["Fixtures"] + path.prefix(2)
        let resource = path.suffix(from: 3).joined(separator: ".")
        
        guard let resourceURL = bundle.url(forResource: resource, withExtension: "json", subdirectory: subdirectory.joined(separator: "/")) else {
            throw FixtureURLError.missingResource(bundle, name: resource, subdirectory: subdirectory)
        }

        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let content = try Data(contentsOf: resourceURL)

        return (response, content)
    }

    override func stopLoading() {
    }
}

extension URLSession {
    static let fixtures: URLSession = {
        let config = URLSessionConfiguration.default
        config.urlCache = nil
        config.protocolClasses = [FixtureURLProtocol.self]

        return URLSession(configuration: config)
    }()
}

extension URL {
    init<T: AnyObject>(fixturesFor _: T, function: String = #function) {
        self.init(fixturesForType: T.self, function: function)
    }

    init<T: AnyObject>(fixturesForType type: T.Type, function: String = #function) {
        let typeString = clean(String(describing: T.self))
        let functionString = clean(function)

        self.init(fixturePath: "/\(typeString)/\(functionString)/", in: Bundle(for: T.self))
    }

    init(fixturePath: String, in bundle: Bundle) {
        self.init(string: fixturePath, relativeTo: URL(string: "fixture://\(bundle.bundleIdentifier!)")!)!
    }
}

private func clean(_ string: String) -> String {
    String(string.filter({ $0.isASCII && ($0.isLetter || $0.isNumber) }))
}
