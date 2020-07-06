//
//  BrowserCoordinator.swift
//  DiscogsStreamer
//
//  Created by Spencer on 7/4/20.
//  Copyright © 2020 Spencer Miles. All rights reserved.
//

import Combine
import Foundation
import UIKit

class BrowserCoordinator {
    private let navigationController: UINavigationController
    private let browserDataSource: BrowserDataSource
    
    /// This tuple maintains a reference to the current view controller and Combine subscriptions
    /// Without this, they'll be descoped and the Combine messages won't fire
    private var content: (viewController: BrowserViewController, Set<AnyCancellable>)?
    
    var onComplete: (() -> Void)?
    
    init(
        navigationController: UINavigationController,
        discogsService: DiscogsService,
        completion: (() -> Void)?) {
        self.navigationController = navigationController
        self.browserDataSource = BrowserDataSource(perPage: 50, service: discogsService)
        self.onComplete = completion
    }
    
    func start(animated: Bool) {
        let browserViewController = BrowserViewController()
        browserViewController.delegate = self
        var subscriptions: Set<AnyCancellable> = []
        
        browserDataSource.$data
            .map { BrowserViewController.Model.init(data: $0) }
            .receive(on: DispatchQueue.main)
            .assign(to: \.model, on: browserViewController)
            .store(in: &subscriptions)
        
        browserViewController.popViewControllerPublisher
            .sink { [weak self] _ in self?.complete() }
            .store(in: &subscriptions)
                    
        navigationController.pushViewController(browserViewController, animated: animated)
        
        self.content = (viewController: browserViewController, subscriptions)
    }
    
    private func complete() {
        onComplete?()
        self.content = nil
    }
}

extension BrowserCoordinator: BrowserViewController.Delegate {
    func itemSelected(itemID: Int, sender _: BrowserViewController) {
        
    }
    
    func itemsRequested(sender _: BrowserViewController) {
        self.browserDataSource.loadMore()
    }
    
    func refreshRequested(sender _: BrowserViewController) {
        self.browserDataSource.reload()
    }
}
