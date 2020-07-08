//
//  BrowserDataSourceTests.swift
//  DiscogsStreamerTests
//
//  Created by Spencer on 7/5/20.
//  Copyright © 2020 Spencer Miles. All rights reserved.
//

import XCTest
@testable import DiscogsStreamer

class BrowserDataSourceTests: XCTestCase {

    let releases = DiscogsService.ReleasesResponse.init(
        pagination: .init(page: 1, pages: 2, perPage: 3, items: 4),
        items: [
            Release(id: 1, title: "Coastal Iridescence 1", year: 2020),
            Release(id: 2, title: "Coastal Iridescence 2", year: 2020),
            Release(id: 3, title: "Coastal Iridescence 3", year: 2020)
    ])
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitialState() throws {
        let service = MockDiscogsService()
        let dataSource = BrowserDataSource(perPage: 50, service: service)
        
        XCTAssertEqual(service.userReleasesMethod.pendingRequests.count, 0)
        XCTAssertEqual(dataSource.data.items.count, 0)
        XCTAssertFalse(dataSource.data.didFail)
        XCTAssertFalse(dataSource.data.isLoading)
        XCTAssertTrue(dataSource.data.canLoadMore)
    }
    
    func testFirstRequest() throws {
        let service = MockDiscogsService()
        let dataSource = BrowserDataSource(perPage: 50, service: service)
  
        dataSource.loadMore()
        
        XCTAssertEqual(service.userReleasesMethod.pendingRequests.count, 1)
        XCTAssertEqual(service.userReleasesMethod.pendingRequests.first?.page, 1)
    }
      
    func testPaginationRequests() throws {
        let service = MockDiscogsService()
        let dataSource = BrowserDataSource(perPage: 3, service: service)
        
        dataSource.loadMore()
        
        XCTAssertEqual(service.userReleasesMethod.pendingRequests.count, 1)
        XCTAssertEqual(service.userReleasesMethod.pendingRequests.first?.page, 1)

        service.userReleasesMethod.succeed(response: releases)
        XCTAssertTrue(dataSource.data.isLoading)
        waitForNextLoop()
        
        XCTAssertEqual(dataSource.data.items.count, 3)
        XCTAssertTrue(dataSource.data.canLoadMore)
        XCTAssertFalse(dataSource.data.didFail)
        XCTAssertFalse(dataSource.data.isLoading)
        XCTAssertFalse(dataSource.data.isReloading)

        // Load another batch
        dataSource.loadMore()
        
        XCTAssertEqual(service.userReleasesMethod.pendingRequests.count, 1)
        XCTAssertEqual(service.userReleasesMethod.pendingRequests.first?.page, 2)
        XCTAssertTrue(dataSource.data.isLoading)

        service.userReleasesMethod.succeed(response:
            .init(
                pagination: .init(page: 2, pages: 2, perPage: 3, items: 4),
                items: [
                    Release(id: 1, title: "Coastal Iridescence 4", year: 2020)
            ]))
        waitForNextLoop()

        XCTAssertEqual(dataSource.data.items.count, 4)
        XCTAssertFalse(dataSource.data.canLoadMore)
        XCTAssertFalse(dataSource.data.isLoading)
        
        // Try loading more, which should be a no-op
        dataSource.loadMore()
        XCTAssertFalse(dataSource.data.isLoading)
    }
    
      func testReload() throws {
        let service = MockDiscogsService()
        let dataSource = BrowserDataSource(perPage: 3, service: service)
        
        dataSource.loadMore()
        service.userReleasesMethod.succeed(response: releases)
        waitForNextLoop()
        XCTAssertEqual(dataSource.data.items.count, 3)

        // Now reload with empty payload, and ensure nothing is present
        dataSource.reload()
        
        XCTAssertEqual(service.userReleasesMethod.pendingRequests.count, 1)
        XCTAssertEqual(service.userReleasesMethod.pendingRequests.first?.page, 1)
        
        service.userReleasesMethod.succeed(response: .init(
            pagination: .init(page: 1, pages: 1, perPage: 5, items: 9),
            items: []))
        waitForNextLoop()
        
        XCTAssertEqual(dataSource.data.items.count, 0)

    }
}
