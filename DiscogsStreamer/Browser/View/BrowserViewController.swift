//
//  BrowserViewController.swift
//  DiscogsStreamer
//
//  Created by Spencer on 7/4/20.
//  Copyright © 2020 Spencer Miles. All rights reserved.
//

import UIKit

protocol _BrowserViewControllerDelegate: AnyObject {
    func itemsRequested(sender _: BrowserViewController)
    func refreshRequested(sender _: BrowserViewController)
    func itemSelected(itemID: Browseable.ID, sender _: BrowserViewController)
}

protocol BrowseableCell {
    var id: Int { get }
    var name: String { get }
    var model: BrowseableItemTableViewCell.Model { get }
}

private enum BrowseableItem {
    typealias ID = Int
    
    case release(Release)
}

extension BrowseableItem {
    var displayName: String {
        switch self {
        case .release(let release):
            return release.displayName
        }
    }
    
    var id: BrowseableItem.ID {
        switch self {
        case .release(let release):
            return release.id
        }
    }
}

class BrowserViewController: BaseViewController {
    typealias Delegate = _BrowserViewControllerDelegate
    
    struct Model {
        var cells: [BrowseableCell] = []
        var refreshControlRefreshing = false
        var loadingCell = false
        var errorCell = false
        
        struct BrowseableFolderCell: BrowseableCell {
            var id: Int
            var name: String
            var model: BrowseableItemTableViewCell.Model
        }
        
        struct BrowseableReleaseCell: BrowseableCell {
            var id: Int
            var name: String
            var model: BrowseableItemTableViewCell.Model
        }

        init() { }
        
        init(data: BrowserDataSource.Data) {
            self.cells = data.items.compactMap {
                // TODO: Clean this up, override init methods
                // TODO: Extend this to support Folder types
                BrowseableReleaseCell(
                    id: $0.id,
                    name: $0.displayName,
                    model: .init(title: $0.displayName, subtitle: nil))
            }
        }
    }
    
    private enum Section: Int, Hashable {
        case items
        case error
        case loading
    }

    private enum Row: Hashable {
        case item(BrowseableItem.ID)
        case loading
        case error
    }
    
    private typealias TableViewDataSource = UITableViewDiffableDataSource<Section, Row>

    private var tableViewDataSource: TableViewDataSource?
    var model: Model {
        didSet {
            applyModel()
        }
    }
    
    weak var delegate: Delegate?
    
    private var tableView: UITableView {
        view as! UITableView
    }
    
    init(model: Model = Model()) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        self.title = "Releases"
        
        let view = UITableView()
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        view.tableFooterView = UIView()
        view.estimatedRowHeight = 60

        view.register(BrowseableItemTableViewCell.self, forCellReuseIdentifier: BrowseableItemTableViewCell.reuseIdentifier)
//        view.register(ItemListErrorCell.self)
//        view.register(ItemListLoadingCell.self)
//        view.register(ItemListItemCell.self)

        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewDataSource = .init(tableView: tableView) { [weak self] in
            self?.dequeueCell(forRow: $2, at: $1)
        }

        tableView.dataSource = tableViewDataSource
        tableView.delegate = self

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pulledToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        // Load the items
        requestItems()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyModel(animated: false)
    }
    
    private func dequeueCell(forRow row: Row, at indexPath: IndexPath) -> UITableViewCell? {
        switch row {
        case .item(let id):
            guard let cellModel = model.cells.first(where: { $0.id == id })?.model else {
                return nil
            }
            
            let cell: BrowseableItemTableViewCell = tableView.dequeueReusableCell(
                withIdentifier: BrowseableItemTableViewCell.reuseIdentifier,
                for: indexPath)
                as! BrowseableItemTableViewCell
            cell.model = cellModel
            
            return cell
            
        case .error:
            return nil
            
        case .loading:
            return nil
        }
    }
    
    private func refreshCell(forRow row: Row, at indexPath: IndexPath) {
        switch row {
        case .item:
            let cell = tableView.cellForRow(at: indexPath) as! BrowseableItemTableViewCell
            cell.model = model.cells[indexPath.row].model

        case .loading:
            break

        case .error:
            break
        }
    }
    
    private func applyModel(animated: Bool = true) {
        guard viewIfLoaded?.window != nil, let tableViewDataSource = tableViewDataSource else {
            return
        }

//        if model.refreshControlRefreshing {
//            tableView.refreshControl?.beginRefreshing()
//        } else {
//            tableView.refreshControl?.endRefreshing()
//        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, Row>()

        snapshot.appendSections([.items])
        let items = model.cells.map({ Row.item($0.id) })
        snapshot.appendItems(items, toSection: .items)

        if model.loadingCell {
            snapshot.appendSections([.loading])
            snapshot.appendItems([.loading], toSection: .loading)
        }

        if model.errorCell {
            snapshot.appendSections([.error])
            snapshot.appendItems([.error], toSection: .error)
        }

        tableViewDataSource.apply(snapshot, animatingDifferences: animated) {
            // After applying changes, there might still be a loading cell visible.
            // If there is, we need to request more items.
//            if self.tableView.visibleCells.contains(where: { $0 is ItemListLoadingCell }) {
//                self.requestItems()
//            }
            
            // The data source handles inserts/removes but we still need to refresh the visible cells' models.
            self.tableView.indexPathsForVisibleRows?.forEach {
                self.refreshCell(forRow: snapshot.itemIdentifier(at: $0), at: $0)
            }
        }
    }
    
    @objc private func pulledToRefresh() {
        
    }
    
    private func requestItems() {
        self.delegate?.itemsRequested(sender: self)
    }
}

extension BrowserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if cell is ItemListLoadingCell {
//            requestItems()
//        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard case .items? = Section(rawValue: indexPath.section), model.cells.indices ~= indexPath.row else {
            return
        }

//        delegate?.itemSelected(itemID: model.itemCells[indexPath.row].id, sender: self)
    }
}
