//
//  DiscogsClient.swift
//  DiscogsStreamer
//
//  Created by Spencer on 7/4/20.
//  Copyright © 2020 Spencer Miles. All rights reserved.
//

import Combine
import Foundation

private extension Environment {
    var discogsServiceBaseURL: URL {
        switch self {
        case .production:
            return URL(string: "https://api.discogs.com")!
        }
    }
}

/// A concrete implementation of the DiscogsService
class DiscogsClient {
    private let baseURL: URL
    private let session: URLSession
    private var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    init(baseURL: URL = Environment.current.discogsServiceBaseURL,
         session: URLSession = URLSession(configuration: URLSessionConfiguration.default))
    {
        self.baseURL = baseURL
        self.session = session
    }
}

extension DiscogsClient: DiscogsService {
    func userFolders(for request: UserFoldersRequest) -> AnyPublisher<FoldersResponse, Error> {
        let url = URL(string: "users/\(request.username)/collection/folders", relativeTo: baseURL)!
        
        return session.dataTaskPublisher(for: url)
            .httpSuccess()
            .map { $0.0 }
            .decode(type: RawFoldersResponse.self, decoder: jsonDecoder)
            .map { FoldersResponse($0) }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func userReleases(for request: UserReleasesRequest) -> AnyPublisher<CollectionReleasesResponse, Error> {
        let url = URL(string: "users/\(request.username)/collection/folders/\(request.folderId)/releases?page=\(request.page)&sort=\(request.sort)&sort_order=\(request.sortOrder)", relativeTo: baseURL)!
        
        return session.dataTaskPublisher(for: url)
            .httpSuccess()
            .map { $0.0 }
            .decode(type: RawCollectionReleasesResponse.self, decoder: jsonDecoder)
            .map { CollectionReleasesResponse($0) }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func release(for request: ReleaseRequest) -> AnyPublisher<ReleaseResponse, Error> {
        let url = URL(string: "releases/\(request.releaseId)", relativeTo: baseURL)!
        
        return session.dataTaskPublisher(for: url)
            .httpSuccess()
            .map { $0.0 }
            .decode(type: RawRelease.self, decoder: jsonDecoder)
            .map { ReleaseResponse($0) }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}

// MARK: - Network Models and Model Conversion

// MARK: Responses

private extension FoldersResponse {
    init(_ response: RawFoldersResponse) {
        self.init(
            folders: response.folders.compactMap({ Folder($0) })
        )
    }
}

private extension ReleaseResponse {
    init(_ rawRelease: RawRelease) {
        self.init(release: Release(rawRelease))
    }
}

private extension CollectionReleasesResponse {
    init(_ response: RawCollectionReleasesResponse) {
        self.init(
            pagination: Pagination(response.pagination),
            items: response.releases.compactMap { Release($0) }
        )
    }
}

// MARK: Folders

private struct RawFoldersResponse: Decodable {
    let folders: [RawFolder]
}

private struct RawFolder: Decodable {
    let count: Int
    let id: Int
    let name: String
    let resourceUrl: String
}

private extension Folder {
    init(_ folder: RawFolder) {
        self.init(
            id: folder.id,
            displayName: folder.name,
            resourceURL: URL(string: folder.resourceUrl),
            count: folder.count)
    }
}

// MARK: Pagination

private struct RawPagination: Decodable {
    let page: UInt
    let pages: UInt
    let perPage: UInt
    let items: UInt
}

private extension Pagination {
    init(_ pagination: RawPagination) {
        self.init(
            page: pagination.page,
            pages: pagination.pages,
            perPage: pagination.perPage,
            items: pagination.items)
    }
}

// MARK: Release
private struct RawRelease: Decodable {
    let artists: [RawReleaseArtist]
    let community: RawCommunity
    let country: String?
    let dateAdded: String
    let labels: [RawReleaseRecordLabel]
    let id: Int
    let notes: String?
    let resourceUrl: String
    let title: String
    let tracklist: [RawTrack]
    let videos: [RawVideo]
    let year: UInt
}

private extension Release {
    init(_ release: RawRelease) {
        self.init(
            id: release.id,
            resourceURL: URL(string: release.resourceUrl),
            artists: release.artists.compactMap({ Artist($0) }),
            community: Community(release.community),
            country: release.country,
            dateAdded: ISO8601DateFormatter().date(from: release.dateAdded),
            notes: release.notes,
            recordLabels: release.labels.compactMap({ RecordLabel($0) }),
            title: release.title,
            tracklist: release.tracklist.compactMap({ Release.Track($0) }),
            videos: release.videos.compactMap({ Video($0) }),
            year: release.year)
    }
}


// MARK: Collection Releases

private struct RawCollectionReleasesResponse: Decodable {
    let pagination: RawPagination
    let releases: [RawCollectionRelease]
}

private struct RawCollectionRelease: Decodable {
    
    struct RawCollectionReleaseBasicInformation: Decodable {
        let artists: [RawReleaseArtist]
        let labels: [RawReleaseRecordLabel]
        let masterId: Int
        let masterUrl: String?
        let resourceUrl: String
        let title: String
        let year: UInt
    }
    
    let id: Int
    let instanceId: Int
    let basicInformation: RawCollectionReleaseBasicInformation
}

private extension Release {
    init?(_ collectionRelease: RawCollectionRelease) {
        self.init(
            id: collectionRelease.instanceId,
            resourceURL: URL(string: collectionRelease.basicInformation.resourceUrl),
            artists: collectionRelease.basicInformation.artists.compactMap({ Artist($0) }),
            community: nil,
            recordLabels: collectionRelease.basicInformation.labels.compactMap({ RecordLabel($0) }),
            title: collectionRelease.basicInformation.title,
            year: collectionRelease.basicInformation.year)
    }
}

// MARK: Community

struct RawCommunity: Decodable {
    let have: UInt?
    let want: UInt?
    let rating: RawRating
    
    struct RawRating: Decodable {
        let count: UInt?
        let average: Double
    }
}

private extension Release.Community {
    init?(_ community: RawCommunity) {
        self.init(
            have: community.have,
            want: community.want,
            rating: Rating(
                count: community.rating.count,
                average: community.rating.average))
    }
}

// MARK: Artist

private struct RawReleaseArtist: Decodable {
    var id: Int
    var name: String
    var role: String?
    var resourceUrl: String?
}

private extension Artist {
    init?(_ artist: RawReleaseArtist) {
        var resourceURL: URL?
        if let resourceUrlString = artist.resourceUrl {
            resourceURL = URL(string: resourceUrlString)
        }
        
        self.init(
            id: artist.id,
            name: artist.name,
            resourceURL: resourceURL)
    }
}

// MARK: Record Label

struct RawReleaseRecordLabel: Decodable {
    var id: Int
    var name: String
    var catno: String?
    var resourceUrl: String?
}

private extension RecordLabel {
    init?(_ recordLabel: RawReleaseRecordLabel) {
        var resourceURL: URL?
        if let resourceUrlString = recordLabel.resourceUrl {
            resourceURL = URL(string: resourceUrlString)
        }

        self.init(
            id: recordLabel.id,
            name: recordLabel.name,
            resourceURL: resourceURL,
            catalogNumber: recordLabel.catno)
    }
}

// MARK: Track

struct RawTrack: Decodable {
    let duration: String
    let position: String
    let title: String
}

private extension Release.Track {
    init(_ track: RawTrack) {
        self.init(
            duration: track.duration,
            position: track.position,
            title: track.title.trimmingCharacters(in: .whitespacesAndNewlines))
    }
}

// MARK: Video

struct RawVideo: Decodable {
    let description: String
    let duration: UInt
    let embed: Bool
    let title: String
    let uri: URL
}

private extension Release.Video {
    init(_ video: RawVideo) {
        self.init(
            description: video.description,
            duration: video.duration,
            embed: video.embed,
            title: video.title,
            url: video.uri)
    }
}
