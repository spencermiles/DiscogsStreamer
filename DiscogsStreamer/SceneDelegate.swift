//
//  SceneDelegate.swift
//  DiscogsStreamer
//
//  Created by Spencer on 7/4/20.
//  Copyright © 2020 Spencer Miles. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private let discogsClient = DiscogsClient()
    private var coordinator: MainCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            self.window = window
            
            let coordinator = MainCoordinator(window: window, discogsService: discogsClient)
            self.coordinator = coordinator

            coordinator.start()

            window.makeKeyAndVisible()
        }
    }


}

