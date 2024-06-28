//
//  SceneDelegate.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 03/06/2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private var previousNavigationController: UINavigationController?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let mainVC = RMTabViewController()
        mainVC.delegate = self
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = mainVC
        previousNavigationController = mainVC.viewControllers?.first as? UINavigationController
        window.makeKeyAndVisible()
        
        self.window = window
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
            object: nil,
            userInfo: ["viewController": currentViewController]
        )
        
        return true
    }
}

