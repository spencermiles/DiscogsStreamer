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
    let userFoldersMethod = MockRemoteMethod<UserFoldersRequest, FoldersResponse>()
    let userReleasesMethod = MockRemoteMethod<UserReleasesRequest, DiscogsService.ReleasesResponse>()
    let releaseMethod = MockRemoteMethod<ReleaseRequest, ReleaseResponse>()

    func userFolders(for request: UserFoldersRequest) -> AnyPublisher<FoldersResponse, Error> {
        userFoldersMethod.publisher(for: request).eraseToAnyPublisher()
    }
    
    func userReleases(for request: UserReleasesRequest) -> AnyPublisher<DiscogsService.ReleasesResponse, Error> {
        userReleasesMethod.publisher(for: request).eraseToAnyPublisher()
    }
    
    func release(for request: ReleaseRequest) -> AnyPublisher<ReleaseResponse, Error> {
        releaseMethod.publisher(for: request).eraseToAnyPublisher()
    }
}
