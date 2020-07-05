//
//  Artist.swift
//  DiscogsStreamer
//
//  Created by Spencer on 7/5/20.
//  Copyright © 2020 Spencer Miles. All rights reserved.
//

import Foundation

struct Artist {
    let id: Int
    let name: String
    let resourceURL: URL?
    
    init(id: Int,
         name: String,
         resourceURL: URL? = nil)
    {
        self.id = id
        self.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        self.resourceURL = resourceURL
    }
}
