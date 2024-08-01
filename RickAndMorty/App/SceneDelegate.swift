//
//  SceneDelegate.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 03/06/2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: RMAppCoordinator?
    private var previousNavigationController: UINavigationController?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window

        setupCoordination()

        // Apply Dark/Light mode
        RMThemeManager().applyCurrentTheme()
    }
}

// MARK: - SetupCoordination
extension SceneDelegate {
    private func setupCoordination() {
        appCoordinator = RMAppCoordinator(window: window)
        // Settings for double tap scrolling
        let tabBarViewController = appCoordinator?.tabBarViewController
        tabBarViewController?.delegate = self
        previousNavigationController = tabBarViewController?.viewControllers?.first as? UINavigationController

        appCoordinator?.start()
    }
}

// MARK: - UITabBarControllerDelegate
extension SceneDelegate: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let currentNavigationController = viewController as? UINavigationController else {
            return true
        }

        guard previousNavigationController == currentNavigationController else {
            previousNavigationController = currentNavigationController
            return true
        }

        guard let currentViewController = currentNavigationController.topViewController,
              currentViewController == currentNavigationController.viewControllers.first
        else {
            return true
        }

        NotificationCenter.default.post(
            name: .tabBarItemDoubleTapped,
            object: nil
        )

        return true
    }
}
