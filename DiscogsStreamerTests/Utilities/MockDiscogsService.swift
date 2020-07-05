//
//  MockDiscogsService.swift
//  DiscogsStreamerTests
//
//  Created by Spencer on 7/4/20.
//  Copyright © 2020 Spencer Miles. All rights reserved.
//

import Combine
import Foundation
@testable import DiscogsStreamer

class MockDiscogsService: DiscogsService {
    private let userFoldersMethod = MockRemoteMethod<UserFoldersRequest, FoldersResponse>()
    private let userReleasesMethod = MockRemoteMethod<UserReleasesRequest, ReleasesResponse>()

    func userFolders(for request: UserFoldersRequest) -> AnyPublisher<FoldersResponse, Error> {
        userFoldersMethod.publisher(for: request).eraseToAnyPublisher()
    }
    
    func userReleases(for request: UserReleasesRequest) -> AnyPublisher<ReleasesResponse, Error> {
        userReleasesMethod.publisher(for: request).eraseToAnyPublisher()
    }
}
