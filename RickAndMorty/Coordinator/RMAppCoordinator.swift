//
//  RMAppCoordinator.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 16/07/2024.
//
import UIKit

class RMAppCoordinator: RMBaseCoordinator {

    var tabBarViewController = RMTabViewController()

    override func start() {
        tabBarViewController = RMTabViewController()
        tabBarViewController.coordinator = self

        // Initialise child coordinators
        var viewControllers = [UIViewController]()

        CoordinatorsConfig.allCases.forEach {
            let coordinator = $0.coordinator
            childCoordinators.append(coordinator)
            coordinator.parentCoordinator = self
            coordinator.start()
            viewControllers.append(coordinator.navigationController)
        }

        // MainTabBar
        tabBarViewController.viewControllers = viewControllers
        navigationController.setViewControllers([tabBarViewController], animated: false)
    }
}

// MARK: - Coordinator config
private enum CoordinatorsConfig: CaseIterable {
    case character
    case location
    case episode
    case settings

    var coordinator: RMCoordinator {
        switch self {
        case .character:
            createCoordinator(type: RMCharacterCoordinator.self, title: "Characters", imageSystemName: "person", tag: 1)
        case .location:
            createCoordinator(type: RMLocationCoordinator.self, title: "Locations", imageSystemName: "globe", tag: 2)
        case .episode:
            createCoordinator(type: RMEpisodeCoordinator.self, title: "Episodes", imageSystemName: "tv", tag: 3)
        case .settings:
            createCoordinator(type: RMSettingsCoordinator.self, title: "Settings", imageSystemName: "gear", tag: 4)
        }
    }

    private func createCoordinator(type: RMBaseCoordinator.Type, title: String, imageSystemName: String, tag: Int) -> RMBaseCoordinator {
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: imageSystemName), tag: tag)

        return type.init(navigationController: navigationController)
    }
}
