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
// MARK: - VC Implementation
final class RMSearchViewController: UIViewController {
    // Views
    private let searchView: RMSearchViewProtocol
    private let searchInputView: RMSearchInputViewProtocol
    private let resultsView: RMSearchResultsViewProtocol

    private let configType: RMConfigType
    private let resultsHandler: RMSearchResultsHandler
    private let searchViewModel: RMSearchViewViewModelProtocol

    // MARK: - Init
    init(configType: RMConfigType) {
        self.configType = configType
        self.resultsHandler = RMSearchResultsHandler()
        self.searchViewModel = RMSearchViewViewModel(configType: configType)

        self.resultsView = RMSearchResultsView(resultsHandler: resultsHandler)
        self.searchInputView = RMSearchInputView(configType: configType)
        self.searchView = RMSearchView(
            configType: configType,
            searchInputView: searchInputView,
            resultsView: resultsView
        )

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

        searchInputView.presentKeyboard()
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

        searchInputView.delegate = self
        resultsHandler.delegate = self

        setupHandlers()
        addSearchButton()
    }

    private func setupHandlers() {
        searchViewModel.registerProcessSearchHandler { [weak self] in
            self?.searchView.beginSearchProcess()
        }

        searchViewModel.registerOptionChangeBlock { [weak self] tuple in
            self?.searchInputView.update(option: tuple.0, value: tuple.1)
        }

        searchViewModel.registerSearchResultHandler { [weak self] result in
            DispatchQueue.main.async {
                self?.resultsHandler.configure(with: result)
                self?.resultsView.configure(with: result)
                self?.searchView.showSearchResults()
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
        searchInputView.hideKeyboard()
    }

    @objc
    private func orientationDidChange(_ notification: Notification) {
        resultsView.orientationDidChange(notification)
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

// MARK: - RMSearchResultsHandlerDelegate
extension RMSearchViewController: RMSearchResultsHandlerDelegate {

    func didTapLocationAt(index: Int) {
        guard let locationModel = searchViewModel.locationSearchResult(at: index) else {
            return
        }

        let viewController = RMLocationDetailsViewController(location: locationModel)
        navigationItem.largeTitleDisplayMode = .never

        navigationController?.pushViewController(viewController, animated: true)
    }

    func didTapCharacterAt(index: Int) {
        guard let characterModel = searchViewModel.characterSearchResult(at: index) else {
            return
        }

        let viewController = RMCharacterDetailsViewController(viewModel: RMCharacterDetailsViewViewModel(character: characterModel))
        navigationItem.largeTitleDisplayMode = .never

        navigationController?.pushViewController(viewController, animated: true)
    }

    func didTapEpisodeAt(index: Int) {
        guard let episodeModel = searchViewModel.episodeSearchResult(at: index) else {
            return
        }

        let episodeURL = URL(string: episodeModel.url)
        let viewController = RMEpisodeDetailsViewController(url: episodeURL)
        navigationItem.largeTitleDisplayMode = .never

        navigationController?.pushViewController(viewController, animated: true)
    }

    func didLoadMoreResults(with newIndexPath: [IndexPath]?) {
        resultsView.didLoadMoreResults(with: newIndexPath)
    }

    func showLoadingIndicator() {
        resultsView.showLoadingIndicator()
    }
}
