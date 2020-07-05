//
//  Release.swift
//  DiscogsStreamer
//
//  Created by Spencer on 7/5/20.
//  Copyright © 2020 Spencer Miles. All rights reserved.
//

import Foundation

struct Release: Browseable {
    let id: ID
    var displayName: String {
        get {
            let artists = self.artists.compactMap({ $0.name }).joined(separator: " / ")
            return "\(artists) - \(title)"
        }
    }
    var secondaryDisplayName: String? {
        get {
            return self.recordLabels.first?.name
        }
    }
    let resourceURL: URL?

    let artists: [Artist]
    let recordLabels: [RecordLabel]
    let title: String
    
    init(id: ID,
         resourceURL: URL? = nil,
         artists: [Artist] = [],
         recordLabels: [RecordLabel] = [],
         title: String)
    {
        self.id = id
        self.resourceURL = resourceURL
        self.artists = artists
        self.recordLabels = recordLabels
        self.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

