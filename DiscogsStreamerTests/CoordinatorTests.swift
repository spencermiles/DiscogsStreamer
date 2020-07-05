//
//  CoordinatorTests.swift
//  DiscogsStreamerTests
//
//  Created by Spencer on 7/4/20.
//  Copyright © 2020 Spencer Miles. All rights reserved.
//

import XCTest
@testable import DiscogsStreamer

class CoordinatorTests: XCTestCase {

    func testMainCoordinator() throws {
        let window = UIWindow()
        let coordinator = MainCoordinator(window: window, discogsService: MockDiscogsService())
        coordinator.start()
        
        XCTAssertNotNil(window.rootViewController)
    }
    
    func testBrowserCoordinator() throws {
        let navigationController = UINavigationController()
        var completed = 0

        XCTAssertEqual(navigationController.viewControllers.count, 0)

        let coordinator = BrowserCoordinator(
            navigationController: navigationController,
            discogsService: MockDiscogsService(),
            completion: {
                completed += 1
            })
        coordinator.start(animated: false)
        waitForNextLoop()
        
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertEqual(completed, 0)
    }
    
    func testBrowserCoordinatorPop() throws {
        let navigationController = UINavigationController(rootViewController: UIViewController())
        let done = expectation(description: "done")

        let window = UIWindow(windowScene: UIApplication.shared.connectedScenes.first as! UIWindowScene)
        window.rootViewController = navigationController
        
        let coordinator = BrowserCoordinator(
            navigationController: navigationController,
            discogsService: MockDiscogsService(),
            completion: { done.fulfill() })
        window.makeKeyAndVisible()

        coordinator.start(animated: false)
        waitForNextLoop()
        
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        navigationController.popViewController(animated: false)
        
        wait(for: [done], timeout: 1.0)
    }
}
