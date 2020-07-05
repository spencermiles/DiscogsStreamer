//
//  FolderTests.swift
//  DiscogsStreamerTests
//
//  Created by Spencer on 7/4/20.
//  Copyright © 2020 Spencer Miles. All rights reserved.
//

@testable import DiscogsStreamer
import XCTest

class FolderTests: XCTestCase {
    func testFolderInit() throws {
//        let folder = Folder(id: <#T##Folder.ID#>, displayName: <#T##String#>, resourceURL: <#T##URL?#>, count: <#T##Int#>)
        let folder = Folder(
            id: 0,
            displayName: "Default",
            resourceURL: URL(string: "http://discogs.com/folder"),
            count: 5)

        XCTAssertEqual(folder.count, 5)
        XCTAssertEqual(folder.id, 0)
        XCTAssertEqual(folder.displayName, "Default")
        XCTAssertEqual(folder.resourceURL?.absoluteString, "http://discogs.com/folder")
        XCTAssertEqual(folder.secondaryDisplayName, nil)
    }
}
