//
//  RMEpisodeViewController.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 03/06/2024.
//

import UIKit

// Controller to show and search for Episodes
// MARK: - ViewController Implementation
final class RMEpisodeViewController: UIViewController {

    private let episodeListView: RMEpisodeListViewProtocol
    private let collectionHandler: RMEpisodeCollectionHandler
    private let viewModel: RMEpisodeListViewViewModelProtocol

    // MARK: - Init
    init(viewModel: RMEpisodeListViewViewModelProtocol = RMEpisodeListViewViewModel()) {
        self.collectionHandler = RMEpisodeCollectionHandler(viewModel: viewModel)
        self.episodeListView = RMEpisodeListView(collectionHandler: collectionHandler)
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        setupViewModel()
        collectionHandler.delegate = self
        addSearchButton()
        addChangeThemeButton()
    }

    private func setupViewModel() {
        viewModel.delegate = self
        viewModel.fetchEpisodes()
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

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(orientationDidChange),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }

    private func removeObservers() {
        NotificationCenter.default.removeObserver(
            self,
            name: .tabBarItemDoubleTapped,
            object: nil
        )

        NotificationCenter.default.removeObserver(
            self,
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
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
        let viewController = RMSearchViewController(configType: .episode)
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

    @objc
    private func orientationDidChange(_ notification: Notification) {
        episodeListView.orientationDidChange()
    }
}

// MARK: - RMEpisodeCollectionHandlerDelegate
extension RMEpisodeViewController: RMEpisodeCollectionHandlerDelegate {
    func didSelectItemAt(_ index: Int) {
        // Open detail controller for episode
        let episode = viewModel.getEpisode(at: index)
        let viewModel = RMEpisodeDetailsViewViewModel(episode: episode)
        let detailVC = RMEpisodeDetailsViewController(viewModel: viewModel)
        detailVC.navigationItem.largeTitleDisplayMode = .never

        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension RMEpisodeViewController: RMEpisodeListViewViewModelDelegate {
    func didLoadInitialEpisodes() {
        episodeListView.didLoadInitialEpisodes()
    }

    func didLoadMoreEpisodes(with newIndexPath: [IndexPath]) {
        episodeListView.didLoadMoreEpisodes(with: newIndexPath)
    }
}
