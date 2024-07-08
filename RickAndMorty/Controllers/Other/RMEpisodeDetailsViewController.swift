//
//  RMEpisodeDetailsViewController.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 08/06/2024.
//

import UIKit

// View controller to show details about a single episode
final class RMEpisodeDetailsViewController: UIViewController {

    private let viewModel: RMEpisodeDetailsViewViewModel
    private let episodeDetailView = RMEpisodeDetailsView()

    // MARK: - Init
    init(url: URL?) {
        self.viewModel = RMEpisodeDetailsViewViewModel(endpointURL: url)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func loadView() {
        view = episodeDetailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupController()
    }
}

// MARK: - Setup
extension RMEpisodeDetailsViewController {
    private func setupController() {
        title = "Episode"

        episodeDetailView.delegate = self
        viewModel.delegate = self

        viewModel.fetchEpisodeData()

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShare)
        )
    }
}

// MARK: - ActionMethods
extension RMEpisodeDetailsViewController {
    @objc
    private func didTapShare() {
        let itemsToShare = viewModel.getDataToShare()

        let activityViewController = UIActivityViewController(
            activityItems: itemsToShare,
            applicationActivities: nil
        )
        // For iPad: Specify the location where the popover should appear
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.barButtonItem = self.navigationItem.rightBarButtonItem
        }

        self.present(activityViewController, animated: true)
    }
}

// MARK: - RMEpisodeDetailViewViewModelDelegate
extension RMEpisodeDetailsViewController: RMEpisodeDetailsViewViewModelDelegate {
    func didFetchEpisodeDetail() {
        episodeDetailView.configure(with: viewModel)
    }
}

// MARK: - RMEpisodeDetailViewDelegate
extension RMEpisodeDetailsViewController: RMEpisodeDetailsViewDelegate {
    func rmEpisodeDetailView(_ detailView: RMEpisodeDetailsView, didSelect character: RMCharacter) {
        let viewController = RMCharacterDetailsViewController(
            viewModel: RMCharacterDetailsViewViewModel(character: character)
        )
        viewController.title = character.name
        viewController.navigationItem.largeTitleDisplayMode = .never

        navigationController?.pushViewController(viewController, animated: true)
    }
}
