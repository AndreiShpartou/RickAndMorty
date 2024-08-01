//
//  RMAppCoordinator.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 16/07/2024.
//
import UIKit

class RMAppCoordinator: RMBaseCoordinator {

    var tabBarViewController: UITabBarController = RMTabViewController()

    private var characterCoordinator: RMCharacterCoordinator?
    private var locationCoordinator: RMLocationCoordinator?
    private var episodeCoordinator: RMEpisodeCoordinator?
    private var settingsCoordinator: RMSettingsCoordinator?

    private var window: UIWindow?

    // MARK: - Init
    init(window: UIWindow?) {
        self.window = window
        super.init()

        setupCoordinator()
    }

    required init(navigationController: UINavigationController? = nil) {
        fatalError("init(navigationController:) has not been implemented")
    }

    override func start() {
        window?.rootViewController = tabBarViewController
        window?.makeKeyAndVisible()
    }

    // MARK: - Public
    // Head over between child details coordinators
    func showCharacterDetails(for character: RMCharacterProtocol, from coordinator: RMDetailsCoordinator) {
        characterCoordinator?.showCharacterDetails(for: character, from: coordinator)
    }

    func showLocationDetails(for location: RMLocationProtocol, from coordinator: RMDetailsCoordinator) {
        locationCoordinator?.showLocationDetails(for: location, from: coordinator)
    }

    func showEpisodeDetails(for episode: RMEpisodeProtocol, from coordinator: RMDetailsCoordinator) {
        episodeCoordinator?.showEpisodeDetails(for: episode, from: coordinator)
    }

    // MARK: - PrivateSetup
    private func setupSubCoordinators() {
        // Character
        characterCoordinator = createCoordinator(
            type: RMCharacterCoordinator.self,
            title: "Characters",
            imageSystemName: "person",
            tag: 0
        )
        characterCoordinator?.parentCoordinator = self

        // Location
        locationCoordinator = createCoordinator(
            type: RMLocationCoordinator.self,
            title: "Locations",
            imageSystemName: "globe",
            tag: 1
        )
        locationCoordinator?.parentCoordinator = self
        // Episode
        episodeCoordinator = createCoordinator(
            type: RMEpisodeCoordinator.self,
            title: "Episodes",
            imageSystemName: "tv",
            tag: 2
        )
        episodeCoordinator?.parentCoordinator = self
        // Settings
        settingsCoordinator = createCoordinator(
            type: RMSettingsCoordinator.self,
            title: "Settings",
            imageSystemName: "gear",
            tag: 3
        )
    }

    private func setupCoordinator() {
        setupSubCoordinators()
        // MainTabBar
        tabBarViewController.viewControllers = childCoordinators.compactMap {
            return $0.navigationController
        }
    }

    private func createCoordinator<T: RMBaseCoordinator>(type: T.Type, title: String, imageSystemName: String, tag: Int) -> T {
        // Setup Navigation Controller
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(systemName: imageSystemName),
            tag: tag
        )

        let coordinator = type.init(navigationController: navigationController)
        // Additional coordinator settings
        addChildCoordinator(coordinator)
        coordinator.start()

        return coordinator
    }
}
