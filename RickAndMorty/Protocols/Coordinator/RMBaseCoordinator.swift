//
//  RMBaseCoordinator.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 16/07/2024.
//

import UIKit

class RMBaseCoordinator: RMCoordinatorProtocol {
    var navigationController: UINavigationController?
    var childCoordinators: [RMCoordinatorProtocol] = []

    required init(navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
    }

    func start() {}

    func addChildCoordinator(_ coordinator: RMCoordinatorProtocol) {
        childCoordinators.append(coordinator)
    }

    func removeChildCoordinator(_ coordinator: RMCoordinatorProtocol) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
