//
//  RecordLabel.swift
//  DiscogsStreamer
//
//  Created by Spencer on 7/5/20.
//  Copyright © 2020 Spencer Miles. All rights reserved.
//

import Foundation

struct RecordLabel {
    let id: Int
    let name: String
    let resourceURL: URL?
    let catalogNumber: String?

    init(id: Int,
         name: String,
         resourceURL: URL? = nil,
         catalogNumber: String? = nil)
    {
        self.id = id
        self.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        self.resourceURL = resourceURL
        self.catalogNumber = catalogNumber
    }
    
}
