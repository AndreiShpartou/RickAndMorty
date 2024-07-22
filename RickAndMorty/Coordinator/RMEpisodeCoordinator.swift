//
//  RMEpisodeCoordinator.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 16/07/2024.
//

class RMEpisodeCoordinator: RMBaseCoordinator {

    weak var parentCoordinator: RMAppCoordinator?

    override func start() {
        let episodeVC = RMEpisodeViewController()
        episodeVC.coordinator = self

        navigationController?.pushViewController(episodeVC, animated: false)
    }

    // MARK: - Public
    // Direct navigation
    func showEpisodeDetails(for episode: RMEpisodeProtocol) {
        let detailsVC = createVC(for: episode)
        detailsVC.coordinator = self

        navigationController?.pushViewController(detailsVC, animated: true)
    }

    // Head over from another detail VC
    func showEpisodeDetails(for episode: RMEpisodeProtocol, from coordinator: RMDetailsCoordinator) {
        let detailsVC = createVC(for: episode)
        detailsVC.coordinator = coordinator

        coordinator.navigationController?.pushViewController(detailsVC, animated: true)
    }

    // MARK: - Private
    private func createVC(for episode: RMEpisodeProtocol) -> RMEpisodeDetailsViewController {
        let viewModel = RMEpisodeDetailsViewViewModel(episode: episode)
        let detailsVC = RMEpisodeDetailsViewController(viewModel: viewModel)
        detailsVC.navigationItem.largeTitleDisplayMode = .never

        return detailsVC
    }
}

// MARK: - RMDetailsCoordinator
extension RMEpisodeCoordinator: RMDetailsCoordinator {
    func showCharacterDetails(for character: RMCharacterProtocol) {
        parentCoordinator?.showCharacterDetails(for: character, from: self)
    }

    func showLocationDetails(for location: RMLocationProtocol) {
        parentCoordinator?.showLocationDetails(for: location, from: self)
    }
}

// MARK: - RMSearchCoordinator
extension RMEpisodeCoordinator: RMSearchCoordinator {
    func showSearchScene() {
        let searchVC = RMSearchViewController(configType: .episode)
        searchVC.coordinator = self
        searchVC.navigationItem.largeTitleDisplayMode = .never

        navigationController?.pushViewController(searchVC, animated: true)
    }
}
