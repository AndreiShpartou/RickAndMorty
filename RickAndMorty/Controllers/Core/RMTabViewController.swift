//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 03/06/2024.
//

import UIKit

/// Controller to house tabs and root tab controllers
final class RMTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTabs()
    }

    private func setupTabs() {
        let characterVC = RMCharacterViewController()
        let locationVC = RMLocationViewController()
        let episodeVC = RMEpisodeViewController()
        let settingsVC = RMSettingsViewController()

        characterVC.navigationItem.largeTitleDisplayMode = .automatic
        locationVC.navigationItem.largeTitleDisplayMode = .automatic
        episodeVC.navigationItem.largeTitleDisplayMode = .automatic
        settingsVC.navigationItem.largeTitleDisplayMode = .automatic

        let characterNC = UINavigationController(rootViewController: characterVC)
        let locationNC = UINavigationController(rootViewController: locationVC)
        let episodeNC = UINavigationController(rootViewController: episodeVC)
        let settingsNC = UINavigationController(rootViewController: settingsVC)

        characterNC.tabBarItem = UITabBarItem(
            title: "Characters",
            image: UIImage(systemName: "person"),
            tag: 1
        )
        locationNC.tabBarItem = UITabBarItem(
            title: "Locations",
            image: UIImage(systemName: "globe"),
            tag: 2
        )
        episodeNC.tabBarItem = UITabBarItem(
            title: "Episodes",
            image: UIImage(systemName: "tv"),
            tag: 3
        )
        settingsNC.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gear"),
            tag: 4
        )

        let arrayOfNavControllers = [characterNC, locationNC, episodeNC, settingsNC]
        arrayOfNavControllers.forEach {
            $0.navigationBar.prefersLargeTitles = true
        }

        setViewControllers(
            arrayOfNavControllers,
            animated: true
        )
    }
}

