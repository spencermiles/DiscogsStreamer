//
//  BrowseableItemTableViewCellTests.swift
//  DiscogsStreamerTests
//
//  Created by Spencer on 7/6/20.
//  Copyright © 2020 Spencer Miles. All rights reserved.
//

import XCTest
@testable import DiscogsStreamer

class BrowseableItemTableViewCellTests: XCTestCase {
    func testExample() throws {
        let cell = BrowseableItemTableViewCell()
        cell.model = .init(title: "title", subtitle: "subtitle")
        XCTAssertEqual(cell.title.text, "title")
        XCTAssertEqual(cell.subtitle.text, "subtitle")
    }
}
