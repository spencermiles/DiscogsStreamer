//
//  BrowserViewModelTests.swift
//  DiscogsStreamerTests
//
//  Created by Spencer on 7/5/20.
//  Copyright © 2020 Spencer Miles. All rights reserved.
//

import XCTest
@testable import DiscogsStreamer

class BrowserViewModelTests: XCTestCase {
    private let releases: [Release] = {
        let artist = Artist(id: 1, name: "Spencer Miles")

        return [
            Release(id: 1, resourceURL: nil, artists: [artist], recordLabels: [], title: "Coastal Iridescence 1", year: 2020),
            Release(id: 2, resourceURL: nil, artists: [artist], recordLabels: [], title: "Coastal Iridescence 2", year: 2020),
            Release(id: 3, resourceURL: nil, artists: [artist], recordLabels: [], title: "Coastal Iridescence 3", year: 2020)
        ]
    }()
    
    func testEmptyData() {
        let data = BrowserDataSource.Data()
        let model = BrowserViewController.Model(data: data)

        XCTAssertEqual(model.cells.count, 0)
        XCTAssertFalse(model.refreshControlRefreshing)
        XCTAssertFalse(model.loadingCell)
        XCTAssertFalse(model.errorCell)
    }

    func testData() {
        let data = BrowserDataSource.Data(items: releases)
        let model = BrowserViewController.Model(data: data)
        
        XCTAssertEqual(model.cells.count, 3)
        XCTAssertEqual(model.cells.map({ $0.id }), [1, 2, 3])
        XCTAssertEqual(
            model.cells.map({ $0.name }),
            ["Spencer Miles - Coastal Iridescence 1",
             "Spencer Miles - Coastal Iridescence 2",
             "Spencer Miles - Coastal Iridescence 3"])
    }
    
    // TODO: Implement tests for failure and reloading states
}

