//
//  RMBaseCoordinator.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 16/07/2024.
//

import UIKit

class RMBaseCoordinator: RMCoordinator {
    var navigationController: UINavigationController?
    var childCoordinators: [RMCoordinator] = []

    required init(navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
    }

    func start() {}

    func addChildCoordinator(_ coordinator: RMCoordinator) {
        childCoordinators.append(coordinator)
    }

    func removeChildCoordinator(_ coordinator: RMCoordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
