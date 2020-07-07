//
//  DiscogsClientTests.swift
//  DiscogsStreamerTests
//
//  Created by Spencer on 7/4/20.
//  Copyright © 2020 Spencer Miles. All rights reserved.
//

import Combine
import XCTest
@testable import DiscogsStreamer

class DiscogsClientTests: XCTestCase {
    private var tasks: Set<AnyCancellable> = []
    
    // MARK: - User Folder Tests
    
    func testUserFolders() throws {
        let client = DiscogsClient(baseURL: URL(fixturesFor: self, function: "shared"), session: .fixtures)
        let done = expectation(description: "done")
        var result: Result<FoldersResponse, Error>?
            
        client
            .userFolders(for: UserFoldersRequest(username: "test"))
            .resultify()
            .sink {
                result = $0
                done.fulfill()
            }
            .store(in: &tasks)
    
        wait(for: [done], timeout: 3.0)
        
        let response = try result?.get()
        
        XCTAssertEqual(response?.folders.count, 1)
    }
    
    func testUserFoldersUndecodableData() throws {
        let client = DiscogsClient(baseURL: URL(fixturesFor: self, function: "shared"), session: .fixtures)
        let done = expectation(description: "done")
        var result: Result<FoldersResponse, Error>?
            
        client
            .userFolders(for: UserFoldersRequest(username: "nodata"))
            .resultify()
            .sink {
                result = $0
                done.fulfill()
            }
            .store(in: &tasks)
    
        wait(for: [done], timeout: 3.0)
        
        do {
            let _ = try result?.get()
            XCTAssert(false)
        } catch(let error) {
            XCTAssertNotNil(error)
        }
    }
    
    // MARK: - User Releases Tests
    
    func testUserReleases() throws {
        let client = DiscogsClient(baseURL: URL(fixturesFor: self, function: "shared"), session: .fixtures)
        let done = expectation(description: "done")
        var result: Result<CollectionReleasesResponse, Error>?
            
        client
            .userReleases(for: UserReleasesRequest(username: "test", folderId: 0))
            .resultify()
            .sink {
                result = $0
                done.fulfill()
            }
            .store(in: &tasks)
    
        wait(for: [done], timeout: 3.0)
        
        let response = try result?.get()
        
        XCTAssertEqual(response?.pagination.items, 1144)
        XCTAssertEqual(response?.pagination.page, 1)
        XCTAssertEqual(response?.pagination.perPage, 50)
        XCTAssertEqual(response?.pagination.pages, 23)

        XCTAssertEqual(response?.items.count, 50)
        XCTAssertEqual(response?.items.first?.displayName, "E.R.P. / Duplex - Fr-Dpx")
        XCTAssertEqual(response?.items.first?.secondaryDisplayName, nil)
        
        XCTAssertEqual(response?.items[1].displayName, "Minor Science - Second Language")
        XCTAssertEqual(response?.items[1].secondaryDisplayName, "Whities (2020)")

        XCTAssertEqual(response?.items[2].displayName, "Indigo Tracks - Rites And Rituals")
    }
    
    // MARK: - Release Tests
    func testRelease() throws {
        let client = DiscogsClient(baseURL: URL(fixturesFor: self, function: "shared"), session: .fixtures)
        let done = expectation(description: "done")
        var result: Result<ReleaseResponse, Error>?
        
        client
            .release(for: .init(releaseId: 1000))
            .resultify()
            .sink {
                result = $0
                done.fulfill()
            }
            .store(in: &tasks)
        wait(for: [done], timeout: 3.0)
        
        let release = try result?.get().release
        
        XCTAssertEqual(release?.artists.count, 2)
        XCTAssertEqual(release?.community?.have, 82)
        XCTAssertEqual(release?.community?.want, 96)
        XCTAssertEqual(release?.community?.rating.count, 16)
        XCTAssertEqual(release?.community?.rating.average, 4.5)
        XCTAssertEqual(release?.country, "Netherlands")
        XCTAssertEqual(release?.dateAdded, ISO8601DateFormatter().date(from: "2019-07-11T08:20:02-07:00"))
        XCTAssertEqual(release?.displayName, "E.R.P. / Duplex - Fr-Dpx")
        XCTAssertEqual(release?.id, 13864934)
        XCTAssertEqual(release?.notes, nil)
        XCTAssertEqual(release?.recordLabels.count, 1)
        XCTAssertEqual(release?.resourceURL, URL(string: "https://api.discogs.com/releases/13864934"))
        XCTAssertEqual(release?.tracklist.count, 2)
        XCTAssertEqual(release?.tracklist.first?.position, "A")
        XCTAssertEqual(release?.tracklist.first?.title, "Zrx")
        XCTAssertEqual(release?.videos.count, 2)
        XCTAssertEqual(release?.videos.first?.url, URL(string: "https://www.youtube.com/watch?v=-PqHIbWm694"))
        XCTAssertEqual(release?.videos.first?.embed, true)
        XCTAssertEqual(release?.videos.first?.title, "E.R.P. - ZRX [FR-DPX]")
    }
}
