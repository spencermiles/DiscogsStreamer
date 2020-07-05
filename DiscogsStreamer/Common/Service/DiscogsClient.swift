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
    
    func userReleases(for request: UserReleasesRequest) -> AnyPublisher<ReleasesResponse, Error> {
        let url = URL(string: "users/\(request.username)/collection/folders/\(request.folderId)/releases", relativeTo: baseURL)!
        
        return session.dataTaskPublisher(for: url)
            .httpSuccess()
            .map { $0.0 }
            .decode(type: RawReleasesResponse.self, decoder: jsonDecoder)
            .map { ReleasesResponse($0) }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}

// MARK: - Network Models and Model Conversion

// MARK: Folders

private struct RawFoldersResponse: Decodable {
    let folders: [RawFolder]
}

private struct RawFolder: Decodable {
    var count: Int
    var id: Int
    var name: String
    var resourceUrl: String
}

private extension FoldersResponse {
    init(_ response: RawFoldersResponse) {
        self.init(
            folders: response.folders.compactMap({ Folder($0) })
        )
    }
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

// MARK: Releases

private struct RawReleasesResponse: Decodable {
    let releases: [RawRelease]
}

private struct RawRelease: Decodable {
    
    struct RawReleaseBasicInformation: Decodable {
        var artists: [RawReleaseArtist]
        var labels: [RawReleaseRecordLabel]
        var masterId: Int
        var masterUrl: String?
        var resourceUrl: String
        var title: String
        var year: Int
    }
    
    
    var id: Int
    var basicInformation: RawReleaseBasicInformation
}

private extension ReleasesResponse {
    init(_ response: RawReleasesResponse) {
        self.init(
            releases: response.releases.compactMap { Release($0) }
        )
    }
}

private extension Release {
    init?(_ release: RawRelease) {
//        let artistName = release
//            .basicInformation
//            .artists
//            .compactMap({ $0.name })
//            .joined(separator: " / ")
//            .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//        let releaseTitle = release.basicInformation.title
//            .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//        let displayName = "\(artistName) - \(releaseTitle)"

        self.init(
            id: release.id,
            resourceURL: URL(string: release.basicInformation.resourceUrl),
            artists: release.basicInformation.artists.compactMap({ Artist($0) }),
            recordLabels: release.basicInformation.labels.compactMap({ RecordLabel($0) }),
            title: release.basicInformation.title)
    }
}

// MARK: - Artist

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
// MARK: - Record Label

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
