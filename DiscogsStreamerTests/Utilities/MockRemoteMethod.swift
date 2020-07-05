//
//  MockRemoteMethod.swift
//  DiscogsStreamerTests
//
//  Created by Spencer on 7/4/20.
//  Copyright © 2020 Spencer Miles. All rights reserved.
//

import Combine
import Foundation
import XCTest

class MockRemoteMethod<Request, Response> {
    private var futureResults: ArraySlice<Result<Response, Error>> = []
    private var currentRequests: [(Request, PassthroughSubject<Response, Error>)] = []

    var pendingRequests: [Request] {
        return currentRequests.map({ $0.0 })
    }

    func publisher(for request: Request) -> AnyPublisher<Response, Error> {
        switch futureResults.popFirst() {
        case .success(let image):
            return Just(image).setFailureType(to: Error.self).eraseToAnyPublisher()

        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()

        case nil:
            let subject = PassthroughSubject<Response, Error>()

            currentRequests.append((request, subject))

            return subject.eraseToAnyPublisher()
        }
    }

    func preSucceed(response: Response) {
        futureResults.append(.success(response))
    }

    func preFail(error: Error) {
        futureResults.append(.failure(error))
    }

    func succeed(at index: Int = 0, response: Response) {
        guard currentRequests.indices.contains(index) else {
            XCTFail("Cannot succeed request \(index) because request count is \(currentRequests.count)")
            return
        }

        let (_, subject) = currentRequests.remove(at: index)

        subject.send(response)
        subject.send(completion: .finished)
    }

    func fail(at index: Int = 0, error: Error) {
        guard currentRequests.indices.contains(index) else {
            XCTFail("Cannot fail request \(index) because request count is \(currentRequests.count)")
            return
        }

        let (_, subject) = currentRequests.remove(at: index)

        subject.send(completion: .failure(error))
    }
}
