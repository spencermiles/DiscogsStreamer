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
    private let discogsService: DiscogsService
    
    /// This tuple maintains a reference to the current view controller and Combine subscriptions
    /// Without this, they'll be descoped and the Combine messages won't fire
    private var content: (viewController: BrowserViewController, Set<AnyCancellable>)?
    
    var onComplete: (() -> Void)?
    
    init(
        navigationController: UINavigationController,
        discogsService: DiscogsService,
        completion: (() -> Void)?) {
        self.navigationController = navigationController
        self.discogsService = discogsService
        self.onComplete = completion
    }
    
    func start(animated: Bool) {
        let browserViewController = BrowserViewController()
        var subscriptions: Set<AnyCancellable> = []
        
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
