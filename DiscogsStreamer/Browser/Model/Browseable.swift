//
//  Browseable.swift
//  DiscogsStreamer
//
//  Created by Spencer on 7/5/20.
//  Copyright © 2020 Spencer Miles. All rights reserved.
//

import Foundation

protocol Browseable {
    typealias ID = Int
    
    var id: ID { get }
    var displayName: String { get }
    var secondaryDisplayName: String? { get }
    var resourceURL: URL? { get }
}
