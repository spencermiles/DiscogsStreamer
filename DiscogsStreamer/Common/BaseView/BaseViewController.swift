//
//  BaseViewController.swift
//  DiscogsStreamer
//
//  Created by Spencer on 7/4/20.
//  Copyright © 2020 Spencer Miles. All rights reserved.
//

import Combine
import UIKit

class BaseViewController: UIViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: Handle Pop

    private var shouldSendPopEvent: Bool = false

    let popViewControllerPublisher = PassthroughSubject<Void, Never>()

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        shouldSendPopEvent = navigationController != nil
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        guard shouldSendPopEvent,
            navigationController == nil
            else {
                return
        }

        popViewControllerPublisher.send(())
    }
}

