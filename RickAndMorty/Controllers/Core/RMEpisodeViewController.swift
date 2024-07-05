//
//  RMEpisodeViewController.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 03/06/2024.
//

import UIKit

// Controller to show and search for Episodes
final class RMEpisodeViewController: UIViewController {

    private let episodeListView = RMEpisodeListView()

    // MARK: - LifeCycle
    override func loadView() {
        view = episodeListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        addObservers()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateNavigationBar()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        removeObservers()
    }
}

// MARK: - Setup
extension RMEpisodeViewController {
    private func setupController() {
        title = "Episodes"
        addSearchButton()
        addChangeThemeButton()

        episodeListView.delegate = self
    }

    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .search,
            target: self,
            action: #selector(didTapSearch)
        )
    }

    private func addChangeThemeButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "lightbulb"),
            style: .plain,
            target: self,
            action: #selector(didTapChangeTheme)
        )
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(tabBarItemDoubleTapped),
            name: .tabBarItemDoubleTapped,
            object: nil
        )
    }

    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: .tabBarItemDoubleTapped, object: nil)
    }

    private func updateNavigationBar() {
        let isDarkMode = (self.traitCollection.userInterfaceStyle == .dark)
        let iconName = isDarkMode ? "lightbulb" : "lightbulb.fill"
        navigationItem.leftBarButtonItem?.image = UIImage(systemName: iconName)
    }
}

// MARK: - ActionMethods
extension RMEpisodeViewController {
    @objc private func didTapSearch() {
        let viewController = RMSearchViewController(config: .init(type: .episode))
        viewController.navigationItem.largeTitleDisplayMode = .never

        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc
    private func didTapChangeTheme() {
        RMThemeManager.shared.toggleTheme()
    }

    @objc
    private func tabBarItemDoubleTapped(_ notification: Notification) {
        episodeListView.setNilValueForScrollOffset()
    }
}

// MARK: - RMEpisodeListViewDelegate
extension RMEpisodeViewController: RMEpisodeListViewDelegate {
    func rmEpisodeListView(_ episodeListView: RMEpisodeListView, didSelectEpisode episode: RMEpisode) {
        // Open detail controller for that episode
        let detailVC = RMEpisodeDetailsViewController(url: URL(string: episode.url))
        detailVC.navigationItem.largeTitleDisplayMode = .never

        navigationController?.pushViewController(detailVC, animated: true)
    }
}
