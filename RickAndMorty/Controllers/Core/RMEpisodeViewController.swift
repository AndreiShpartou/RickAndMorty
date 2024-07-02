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

    // MARK: - DeInit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - LifeCycle
    override func loadView() {
        episodeListView.delegate = self
        view = episodeListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateNavigationBar()
        }
    }

    // MARK: - Setup
    private func setup() {
        title = "Episodes"
        addSearchButton()
        addChangeThemeButton()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(tabBarItemDoubleTapped),
            name: .tabBarItemDoubleTapped,
            object: nil
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

    private func updateNavigationBar() {
        let isDarkMode = (self.traitCollection.userInterfaceStyle == .dark)
        let iconName = isDarkMode ? "lightbulb" : "lightbulb.fill"
        navigationItem.leftBarButtonItem?.image = UIImage(systemName: iconName)
    }

    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .search,
            target: self,
            action: #selector(didTapSearch)
        )
    }

    @objc
    private func tabBarItemDoubleTapped(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let viewController = userInfo["viewController"] as? UIViewController else {
            return
        }

        if viewController == self {
            episodeListView.setNilValueForScrollOffset()
        }
    }

    @objc
    private func didTapChangeTheme() {
        RMThemeManager.shared.toggleTheme()
    }

    @objc private func didTapSearch() {
        let viewController = RMSearchViewController(config: .init(type: .episode))
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(viewController, animated: true)
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
