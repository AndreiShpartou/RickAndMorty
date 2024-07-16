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

        let navigationController = UINavigationController()
        appCoordinator = RMAppCoordinator(navigationController: navigationController)
        appCoordinator?.start()

        guard let tabBarViewController = appCoordinator?.tabBarViewController else {
            return
        }
        tabBarViewController.delegate = self
        previousNavigationController = tabBarViewController.viewControllers?.first as? UINavigationController

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        self.window = window
        RMThemeManager.shared.applyCurrentTheme()
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
