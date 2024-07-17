//
//  RMLocationCoordinator.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 16/07/2024.
//

import Foundation

class RMLocationCoordinator: RMBaseCoordinator {

    weak var parentCoordinator: RMAppCoordinator?

    override func start() {
        let locationVC = RMLocationViewController()
        locationVC.coordinator = self

        navigationController.pushViewController(locationVC, animated: false)
    }

    // MARK: - Public
    // Direct navigation
    func showLocationDetails(for location: RMLocationProtocol) {
        let detailsVC = getLocationVC(for: location)
        detailsVC.coordinator = self

        navigationController.pushViewController(detailsVC, animated: true)
    }

    // Head over from other coordinators
    func showLocationDetails(for location: RMLocationProtocol, from coordinator: RMDetailsCoordinator) {
        let detailsVC = getLocationVC(for: location)
        detailsVC.coordinator = coordinator

        coordinator.navigationController.pushViewController(detailsVC, animated: true)
    }

    // MARK: - Private
    private func getLocationVC(for location: RMLocationProtocol) -> RMLocationDetailsViewController {
        let viewModel = RMLocationDetailsViewViewModel(location: location)
        let detailsVC = RMLocationDetailsViewController(viewModel: viewModel)
        detailsVC.navigationItem.largeTitleDisplayMode = .never

        return detailsVC
    }
}

extension RMLocationCoordinator: RMDetailsCoordinator {
    func showCharacterDetails(for character: RMCharacterProtocol) {
        parentCoordinator?.showCharacterDetails(for: character, from: self)
    }

    func showEpisodeDetails(for episode: RMEpisodeProtocol) {
        parentCoordinator?.showEpisodeDetails(for: episode, from: self)
    }
}
