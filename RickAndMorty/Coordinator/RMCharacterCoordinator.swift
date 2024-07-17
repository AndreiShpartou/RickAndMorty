//
//  RMCharacterCoordinator.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 16/07/2024.
//

import Foundation

class RMCharacterCoordinator: RMBaseCoordinator {

    weak var parentCoordinator: RMAppCoordinator?

    override func start() {
        let characterVC = RMCharacterViewController()
        characterVC.coordinator = self

        navigationController.pushViewController(characterVC, animated: false)
    }

    // MARK: - Public
    // Direct navigation
    func showCharacterDetails(for character: RMCharacterProtocol) {
        let detailsVC = getDetailVC(for: character)
        detailsVC.coordinator = self

        navigationController.pushViewController(detailsVC, animated: true)
    }

    // Head over from other coordinators
    func showCharacterDetails(for character: RMCharacterProtocol, from coordinator: RMDetailsCoordinator) {
        let detailsVC = getDetailVC(for: character)
        detailsVC.coordinator = coordinator

        coordinator.navigationController.pushViewController(detailsVC, animated: true)
    }

    // MARK: - Private
    private func getDetailVC(for character: RMCharacterProtocol) -> RMCharacterDetailsViewController {
        let viewModel = RMCharacterDetailsViewViewModel(character: character)
        let detailsVC = RMCharacterDetailsViewController(viewModel: viewModel)
        detailsVC.navigationItem.largeTitleDisplayMode = .never

        return detailsVC
    }
}

// MARK: - RMDetailsCoordinator
extension RMCharacterCoordinator: RMDetailsCoordinator {
    func showEpisodeDetails(for episode: RMEpisodeProtocol) {
        parentCoordinator?.showEpisodeDetails(for: episode, from: self)
    }

    func showLocationDetails(for location: RMLocationProtocol) {
        parentCoordinator?.showLocationDetails(for: location, from: self)
    }
}

// MARK: - RMSearchCoordinator
extension RMCharacterCoordinator: RMSearchCoordinator {

    func showSearchScene() {
        let searchVC = RMSearchViewController(configType: .character)
        searchVC.coordinator = self
        searchVC.navigationItem.largeTitleDisplayMode = .never

        navigationController.pushViewController(searchVC, animated: true)
    }
}
