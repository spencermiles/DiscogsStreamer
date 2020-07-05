//
//  BrowserDataSource.swift
//  DiscogsStreamer
//
//  Created by Spencer on 7/5/20.
//  Copyright © 2020 Spencer Miles. All rights reserved.
//

import Foundation

class BrowserDataSource {
    struct Data {
        var items: [Browseable] = []
        var isLoading: Bool = false
        var isReloading: Bool = false
        var canLoadMore: Bool = false
        var didFail: Bool = false
    }
}