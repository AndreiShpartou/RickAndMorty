//
//  RMEpisodeCoordinator.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 16/07/2024.
//

import Foundation

class RMEpisodeCoordinator: RMBaseCoordinator {
    override func start() {
        let episodeVC = RMEpisodeViewController()
        episodeVC.coordinator = self

        navigationController.pushViewController(episodeVC, animated: false)
    }

    func showEpisodeDetails(for episode: RMEpisodeProtocol) {
        let viewModel = RMEpisodeDetailsViewViewModel(episode: episode)
        let detailsVC = RMEpisodeDetailsViewController(viewModel: viewModel)
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

extension RMEpisodeCoordinator: RMEpisodeDetailsViewControllerDelegate {
    func didSelectCharacter(_ character: RMCharacterProtocol) {
        showCharacterDetails(for: character)
    }
}
