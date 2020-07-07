//
//  ReleaseTests.swift
//  DiscogsStreamerTests
//
//  Created by Spencer on 7/5/20.
//  Copyright © 2020 Spencer Miles. All rights reserved.
//

@testable import DiscogsStreamer
import XCTest

class ReleaseTests: XCTestCase {
    let label = RecordLabel(id: 0, name: "Invisible Boundary ")
    
    func testReleaseInit() throws {        
        let release = Release(
            id: 0,
            resourceURL: URL(string: "http://discogs.com/release/1"),
            artists: [Artist(id: 0, name: "Spencer Miles ")],
            community: Release.Community(have: 5, want: 50, rating: .init(count: 5, average: 4.55)),
            recordLabels: [label],
            title: "Coastal Iridescence",
            year: 2020)

        XCTAssertEqual(release.id, 0)
        XCTAssertEqual(release.displayName, "Spencer Miles - Coastal Iridescence")
        XCTAssertEqual(release.artists.count, 1)
        XCTAssertEqual(release.artists.first?.name, "Spencer Miles")
        XCTAssertEqual(release.community?.have, 5)
        XCTAssertEqual(release.community?.want, 50)
        XCTAssertEqual(release.community?.rating.average, 4.55)
        XCTAssertEqual(release.recordLabels.count, 1)
        XCTAssertEqual(release.recordLabels.first?.name, "Invisible Boundary")
        XCTAssertEqual(release.secondaryDisplayName, "Invisible Boundary (2020)")
        XCTAssertEqual(release.resourceURL?.absoluteString, "http://discogs.com/release/1")
    }
    
    func testMultipleArtists() {
        let artists = [
            Artist(id: 0, name: "Spencer Miles "),
            Artist(id: 0, name: "Massimiliano Pagliara")
        ]

        let release = Release(
            id: 0,
            resourceURL: URL(string: "http://discogs.com/release/1"),
            artists: artists,
            recordLabels: [label],
            title: "Coastal Iridescence",
            year: 2020)
        
        XCTAssertEqual(release.displayName, "Spencer Miles / Massimiliano Pagliara - Coastal Iridescence")
    }
    
    func testSecondaryDisplayNoYear() {
        let release = Release(
            id: 0,
            resourceURL: URL(string: "http://discogs.com/release/1"),
            artists: [Artist(id: 0, name: "Spencer Miles ")],
            recordLabels: [label],
            title: "Coastal Iridescence",
            year: nil)
        
        XCTAssertEqual(release.secondaryDisplayName, "Invisible Boundary")
    }
}
