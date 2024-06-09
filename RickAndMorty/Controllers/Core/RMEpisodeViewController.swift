//
//  RMEpisodeViewController.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 03/06/2024.
//

import UIKit

/// Controller to show and search for Episodes
final class RMEpisodeViewController: UIViewController {
    private let episodeListView = RMEpisodeListView()

    // MARK: - LifeCycle
    override func loadView() {
        episodeListView.delegate = self
        view = episodeListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    // MARK: - Setup
    private func setup() {
        title = "Episodes"
    }
}

// MARK: - RMEpisodeListViewDelegate
extension RMEpisodeViewController: RMEpisodeListViewDelegate {
    func rmEpisodeListView(_ episodeListView: RMEpisodeListView, didSelectEpisode episode: RMEpisode) {
        // Open detail controller for that episode
        let detailVC = RMEpisodeDetailViewController(url: URL(string: episode.url))
        detailVC.navigationItem.largeTitleDisplayMode = .never
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
