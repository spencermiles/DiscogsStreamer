//
//  MainCoordinator.swift
//  DiscogsStreamer
//
//  Created by Spencer on 7/4/20.
//  Copyright © 2020 Spencer Miles. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator {
    private let window: UIWindow
    private let discogsService: DiscogsService
    
    private var browserCoordinator: BrowserCoordinator?
    
    init(window: UIWindow, discogsService: DiscogsService) {
        self.window = window
        self.discogsService = discogsService
    }
    
    func start() {
        let navController = UINavigationController()
        navController.pushViewController(UIViewController(), animated: false)
        
        let browserCoordinator = BrowserCoordinator(
            navigationController: navController,
            discogsService: discogsService,
            completion: { fatalError("BrowserCoordinator unexpectedly completed") })
        self.browserCoordinator = browserCoordinator
        
        browserCoordinator.start(animated: false)
        
        window.rootViewController = navController
    }
}
