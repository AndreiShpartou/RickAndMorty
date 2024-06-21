//
//  RMEpisodeDetailsViewController.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 08/06/2024.
//

import UIKit

/// View controller to show details about a single episode
final class RMEpisodeDetailsViewController: UIViewController {
    private let viewModel: RMEpisodeDetailViewViewModel
    
    private let episodeDetailView = RMEpisodeDetailsView()
    
    // MARK: - Init
    init(url: URL?) {
        self.viewModel = RMEpisodeDetailViewViewModel(endpointURL: url)
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
        episodeDetailView.delegate = self
        viewModel.delegate = self

        setupView()
        viewModel.fetchEpisodeData()
    }
    
    // MARK: - SetupView
    private func setupView() {
        title = "Episode"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShare)
        )
    }
    
    @objc
    private func didTapShare() {
        
    }
}

// MARK: - RMEpisodeDetailViewViewModelDelegate
extension RMEpisodeDetailsViewController: RMEpisodeDetailViewViewModelDelegate {
    func didFetchEpisodeDetail() {
        episodeDetailView.configure(with: viewModel)
    }
}

// MARK: - RMEpisodeDetailViewDelegate
extension RMEpisodeDetailsViewController: RMEpisodeDetailsViewDelegate {
    func rmEpisodeDetailView(_ detailView: RMEpisodeDetailsView, didSelect character: RMCharacter) {
        let viewController = RMCharacterDetailsViewController(
            viewModel: .init(character: character)
        )
        viewController.title = character.name
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
}