//
//  RMCharacterCoordinator.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 16/07/2024.
//

import Foundation

class RMCharacterCoordinator: RMBaseCoordinator {
    override func start() {
        let characterVC = RMCharacterViewController()
        characterVC.coordinator = self

        navigationController.pushViewController(characterVC, animated: false)
    }

    func showCharacterDetails(for character: RMCharacterProtocol) {
        let viewModel = RMCharacterDetailsViewViewModel(character: character)
        let detailsVC = RMCharacterDetailsViewController(viewModel: viewModel)
        detailsVC.delegate = self
        detailsVC.navigationItem.largeTitleDisplayMode = .never

        navigationController.pushViewController(detailsVC, animated: true)
    }

    func showEpisodeDetails(for episode: RMEpisodeProtocol) {
        let viewModel = RMEpisodeDetailsViewViewModel(episode: episode)
        let detailsVC = RMEpisodeDetailsViewController(viewModel: viewModel)
        detailsVC.navigationItem.largeTitleDisplayMode = .never

        navigationController.pushViewController(detailsVC, animated: true)
    }
}

extension RMCharacterCoordinator: RMCharacterDetailsViewControllerDelegate {
    func didSelectEpisode(_ episode: RMEpisodeProtocol) {
        showEpisodeDetails(for: episode)
    }
}
