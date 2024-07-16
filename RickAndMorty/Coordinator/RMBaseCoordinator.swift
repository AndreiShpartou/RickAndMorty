//
//  RMBaseCoordinator.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 16/07/2024.
//

import UIKit

class RMBaseCoordinator: RMCoordinator {
    weak var parentCoordinator: RMCoordinator?
    var childCoordinators: [RMCoordinator] = []
    var navigationController: UINavigationController

    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {}
}
