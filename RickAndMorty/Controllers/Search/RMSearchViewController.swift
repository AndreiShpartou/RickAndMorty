//
//  RMSearchViewController.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 09/06/2024.
//

import UIKit

// Dynamic search option view
// Render results
// Render no results zero state
// Searching / API

// Configurable controller to search
final class RMSearchViewController: UIViewController {

    private let configType: RMConfigType
    private let searchView: RMSearchView
    private let searchViewModel: RMSearchViewViewModel
    private let resultsHandler: RMSearchResultsHandler

    // MARK: - Init
    init(configType: RMConfigType) {
        self.configType = configType
        self.searchViewModel = RMSearchViewViewModel(configType: configType)

        self.resultsHandler = RMSearchResultsHandler()
        let resultsView = RMSearchResultsView(resultsHandler: resultsHandler)
        self.searchView = RMSearchView(viewModel: searchViewModel, resultsView: resultsView)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func loadView() {
        view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        addObservers()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        searchView.presentKeyboard()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        removeObservers()
    }
}

// MARK: - Setup
extension RMSearchViewController {
    private func setupController() {
        title = searchViewModel.configType.title

        searchView.delegate = self
        resultsHandler.delegate = self
        setupHandlers()
        addSearchButton()
    }

    private func setupHandlers() {
        searchViewModel.registerProcessSearchHandler { [weak self] in
            self?.searchView.beginSearchProcess()
        }

        searchViewModel.registerOptionChangeBlock { [weak self] tuple in
            self?.searchView.optionBlockDidChange(with: tuple)
        }

        searchViewModel.registerSearchResultHandler { [weak self] result in
            DispatchQueue.main.async {
                self?.resultsHandler.configure(with: result)
                self?.searchView.showSearchResults(for: result)
            }
        }

        searchViewModel.registerNoResultsHandler { [weak self] in
            DispatchQueue.main.async {
                self?.searchView.showNoResults()
            }
        }
    }

    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Search",
            style: .done,
            target: self,
            action: #selector(didTapExecuteSearch)
        )
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(orientationDidChange),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }

    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
}

// MARK: - ActionMethods
extension RMSearchViewController {
    @objc
    private func didTapExecuteSearch() {
        searchViewModel.executeSearch()
        searchView.hideKeyboard()
    }

    @objc
    private func orientationDidChange(_ notification: Notification) {
        searchView.orientationDidChange(notification)
    }
}

// MARK: - RMSearchViewDelegationHandlerProtocol
extension RMSearchViewController: RMSearchInputViewDelegate {
    func rmSearchInputViewDidTapSearchKeyboardButton(_ inputView: RMSearchInputViewProtocol) {
        searchViewModel.executeSearch()
    }

    func rmSearchInputView(_ inputView: RMSearchInputViewProtocol, didChangeSearchText text: String) {
        searchViewModel.set(query: text)
    }

    func rmSearchInputView(_ inputView: RMSearchInputViewProtocol, didSelectOption option: RMDynamicOption) {
        let viewController = RMSearchOptionPickerViewController(option: option) { [weak self] selection in
            DispatchQueue.main.async {
                self?.searchViewModel.set(value: selection, for: option)
            }
        }
        viewController.sheetPresentationController?.detents = [.medium()]
        viewController.sheetPresentationController?.prefersGrabberVisible = true

        present(viewController, animated: true)
    }
}

// MARK: - RMSearchResultsViewDelegate
extension RMSearchViewController: RMSearchResultsViewDelegate {
    func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapLocationAt index: Int) {
        guard let locationModel = searchViewModel.locationSearchResult(at: index) else {
            return
        }

        let viewController = RMLocationDetailsViewController(location: locationModel)
        navigationItem.largeTitleDisplayMode = .never

        navigationController?.pushViewController(viewController, animated: true)
    }

    func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapCharacterAt index: Int) {
        guard let characterModel = searchViewModel.characterSearchResult(at: index) else {
            return
        }

        let viewController = RMCharacterDetailsViewController(viewModel: RMCharacterDetailsViewViewModel(character: characterModel))
        navigationItem.largeTitleDisplayMode = .never

        navigationController?.pushViewController(viewController, animated: true)
    }

    func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapEpisodeAt index: Int) {
        guard let episodeModel = searchViewModel.episodeSearchResult(at: index) else {
            return
        }

        let episodeURL = URL(string: episodeModel.url)
        let viewController = RMEpisodeDetailsViewController(url: episodeURL)
        navigationItem.largeTitleDisplayMode = .never

        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - RMSearchResultsHandlerDelegate
extension RMSearchViewController: RMSearchResultsHandlerDelegate {
}

// MARK: - RMSearchViewDelegate
extension RMSearchViewController: RMSearchViewDelegate {
}
