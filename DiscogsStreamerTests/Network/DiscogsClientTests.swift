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
        var result: Result<ReleasesResponse, Error>?
            
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
}
