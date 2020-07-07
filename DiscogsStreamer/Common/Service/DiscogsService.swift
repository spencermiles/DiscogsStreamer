//
//  DiscogsService.swift
//  DiscogsStreamer
//
//  Created by Spencer on 7/4/20.
//  Copyright © 2020 Spencer Miles. All rights reserved.
//

import Combine
import Foundation

protocol BrowseableResponse {
    var pagination: Pagination { get }
    var items: [Browseable] { get }
}

// MARK: - Requests
struct UserFoldersRequest {
    var username: String
}

struct UserReleasesRequest {
    var username: String
    var folderId: Int
    var page: UInt = 1
    var sort: String = "added"
    var sortOrder: String = "desc"
}

struct ReleaseRequest {
    var releaseId: Int
}

// MARK: - Responses
struct FoldersResponse {
    var folders: [Folder]
}

struct CollectionReleasesResponse: BrowseableResponse {
    var pagination: Pagination
    var items: [Browseable]
}

struct ReleaseResponse {
    var release: Release
}


protocol DiscogsService {
    typealias ItemsResponse = BrowseableResponse
    
    func userFolders(for request: UserFoldersRequest) -> AnyPublisher<FoldersResponse, Error>
    func userReleases(for request: UserReleasesRequest) -> AnyPublisher<CollectionReleasesResponse, Error>
    func release(for request: ReleaseRequest) -> AnyPublisher<ReleaseResponse, Error>
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
