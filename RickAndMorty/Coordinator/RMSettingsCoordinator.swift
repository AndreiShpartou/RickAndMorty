//
//  RMSettingsCoordinator.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 16/07/2024.
//

import Foundation

class RMSettingsCoordinator: RMBaseCoordinator {

    override func start() {
        let settingsVC = RMSettingsViewController()
        settingsVC.coordinator = self

        navigationController.pushViewController(settingsVC, animated: false)
    }
}
