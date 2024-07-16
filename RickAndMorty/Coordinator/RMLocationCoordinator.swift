//
//  RMLocationCoordinator.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 16/07/2024.
//

import Foundation

class RMLocationCoordinator: RMBaseCoordinator {

    override func start() {
        let locationVC = RMLocationViewController()
        locationVC.coordinator = self

        navigationController.pushViewController(locationVC, animated: false)
    }

    func showLocationDetails(for location: RMLocationProtocol) {
        let viewModel = RMLocationDetailsViewViewModel(location: location)
        let detailsVC = RMLocationDetailsViewController(viewModel: viewModel)
        detailsVC.delegate = self
        detailsVC.navigationItem.largeTitleDisplayMode = .never

        navigationController.pushViewController(detailsVC, animated: true)
    }

    func showCharacterDetails(for character: RMCharacterProtocol) {
        let viewModel = RMCharacterDetailsViewViewModel(character: character)
        let detailsVC = RMCharacterDetailsViewController(viewModel: viewModel)
        detailsVC.title = character.name
        detailsVC.navigationItem.largeTitleDisplayMode = .never

        navigationController.pushViewController(detailsVC, animated: true)
    }
}

extension RMLocationCoordinator: RMLocationDetailsViewControllerDelegate {
    func didSelectCharacter(_ character: RMCharacterProtocol) {
        showCharacterDetails(for: character)
    }
}
