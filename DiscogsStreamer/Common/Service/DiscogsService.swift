//
//  DiscogsService.swift
//  DiscogsStreamer
//
//  Created by Spencer on 7/4/20.
//  Copyright © 2020 Spencer Miles. All rights reserved.
//

import Combine
import Foundation

struct UserFoldersRequest {
    var username: String
}

struct UserReleasesRequest {
    var username: String
    var folderId: Int
}

struct FoldersResponse {
    var folders: [Folder]
}

struct ReleasesResponse {
    var releases: [Release]
}

protocol DiscogsService {
    func userFolders(for request: UserFoldersRequest) -> AnyPublisher<FoldersResponse, Error>
    func userReleases(for request: UserReleasesRequest) -> AnyPublisher<ReleasesResponse, Error>
}

//// MARK: Error Models
//
//enum DiscogsError: LocalizedError {
//    case genericError(error: Error)
//}
//
//extension Error {
//    var discogsError: DiscogsError {
//        (self as? DiscogsError) ?? .genericError(error: self)
//    }
//}
