//
//  BrowserViewController.swift
//  DiscogsStreamer
//
//  Created by Spencer on 7/4/20.
//  Copyright © 2020 Spencer Miles. All rights reserved.
//

import UIKit

protocol BrowsableItemCell {
    var id: Int { get }
    var name: String { get }
}

private enum BrowsableItem {
    typealias ID = Int
    
    case release(Release)
}

extension BrowsableItem {
    var displayName: String {
        switch self {
        case .release(let release):
            return release.displayName
        }
    }
}

class BrowserViewController: BaseViewController {

    struct Model {
        fileprivate var itemCells: [BrowsableItem] = []
        var refreshControlRefreshing = false
        var loadingCell = false
        var errorCell = false
        
        struct BrowsableFolderCell: BrowsableItemCell {
            var id: Int
            var name: String
        }
        
        struct BrowsableReleaseCell: BrowsableItemCell {
            var id: Int
            var name: String
        }

    }
    
    private enum Section: Int, Hashable {
        case items
        case error
        case loading
    }

    private enum Row: Hashable {
        case item(BrowsableItem.ID)
        case loading
        case error
    }
    
    private typealias TableViewDataSource = UITableViewDiffableDataSource<Section, Row>

    private var tableViewDataSource: TableViewDataSource?
    private var model: Model
    
    init(model: Model = Model()) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

}
