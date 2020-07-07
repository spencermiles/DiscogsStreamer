//
//  Release.swift
//  DiscogsStreamer
//
//  Created by Spencer on 7/5/20.
//  Copyright © 2020 Spencer Miles. All rights reserved.
//

import Foundation

struct Release: Browseable {
    // MARK: Browseable
    let id: ID
    var displayName: String {
        get {
            let artists = self.artists.compactMap({ $0.name }).joined(separator: " / ")
            return "\(artists) - \(title)"
        }
    }
    var secondaryDisplayName: String? {
        get {
            guard let labelName = self.recordLabels.first?.name else {
                return nil
            }
            
            return (year != nil) ? "\(labelName) (\(year!))" : labelName
        }
    }
    let resourceURL: URL?

    // MARK: Release
    let artists: [Artist]
    let community: Community?
    let country: String?
    let dateAdded: Date?
    let notes: String?
    let recordLabels: [RecordLabel]
    let title: String
    let tracklist: [Track]
    let videos: [Video]
    let year: UInt?
    
    init(id: ID,
         resourceURL: URL? = nil,
         artists: [Artist] = [],
         community: Community? = nil,
         country: String? = nil,
         dateAdded: Date? = nil,
         notes: String? = nil,
         recordLabels: [RecordLabel] = [],
         title: String,
         tracklist: [Track] = [],
         videos: [Video] = [],
         year: UInt?)
    {
        self.id = id
        self.resourceURL = resourceURL
        self.artists = artists
        self.community = community
        self.country = country
        self.dateAdded = dateAdded
        self.notes = notes
        self.recordLabels = recordLabels
        self.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        self.tracklist = tracklist
        self.videos = videos
        self.year = year
    }
    
    struct Community {
        let have: UInt?
        let want: UInt?
        let rating: Rating
        
        struct Rating {
            let count: UInt?
            let average: Double
        }
    }
    
    struct Track {
        let duration: String
        let position: String
        let title: String
    }
    
    struct Video {
        let description: String
        let duration: UInt
        let embed: Bool
        let title: String
        let url: URL
    }
}

