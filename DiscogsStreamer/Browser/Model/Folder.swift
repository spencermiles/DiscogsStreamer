//
//  Folder.swift
//  DiscogsStreamer
//
//  Created by Spencer on 7/4/20.
//  Copyright © 2020 Spencer Miles. All rights reserved.
//

import Foundation

struct Folder: Browseable {
    var id: ID
    var displayName: String
    var resourceURL: URL?
    var secondaryDisplayName: String? {
        get {
            return nil
        }
    }

    var count: Int
}
