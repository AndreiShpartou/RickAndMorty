//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 03/06/2024.
//

import UIKit

// Controller to house tabs and root tab controllers
final class RMTabViewController: UITabBarController {

    weak var coordinator: RMAppCoordinator?

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
}
