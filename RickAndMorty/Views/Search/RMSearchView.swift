//
//  RMSearchView.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 13/06/2024.
//

import UIKit

protocol RMSearchViewDelegate: AnyObject {
    func rmSearchView(
        _ searchView: RMSearchView,
        didSelectOption option: RMSearchInputViewViewModel.DynamicOption
    )

    func rmSearchView(
        _ searchView: RMSearchView,
        didSelectLocation location: RMLocation
    )

    func rmSearchView(
        _ searchView: RMSearchView,
        didSelectCharacter character: RMCharacter
    )

    func rmSearchView(
        _ searchView: RMSearchView,
        didSelectEpisode episode: RMEpisode
    )
}

final class RMSearchView: UIView {

    weak var delegate: RMSearchViewDelegate?

    let viewModel: RMSearchViewViewModel

    // MARK: - Subviews

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        return spinner
    }()

    // SearchInputView(bar, selection buttons)
    private let searchInputView = RMSearchInputView()

    // No results view
    private let noResultsView = RMNoSearchResultsView()

    // Results collectionView / TableView
    private let resultsView = RMSearchResultsView()

    // MARK: - Init
    init(frame: CGRect, viewModel: RMSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - SetupView
    private func setupView() {
        backgroundColor = .systemBackground

        addSubviews(noResultsView, searchInputView, resultsView, spinner)
        searchInputView.configure(
            with: RMSearchInputViewViewModel(type: viewModel.config.type)
        )
        searchInputView.delegate = self
        resultsView.delegate = self

        setupHandlers()
        addConstraints()
    }

    private func setupHandlers() {

        viewModel.registerProcessSearchHandler { [weak self] in
            self?.spinner.startAnimating()
        }

        viewModel.registerOptionChangeBlock { [weak self] tuple in
            self?.searchInputView.update(option: tuple.0, value: tuple.1)
        }

        viewModel.registerSearchResultHandler { [weak self] result in
            DispatchQueue.main.async {
                self?.resultsView.configure(with: result)
                self?.noResultsView.isHidden = true
                self?.resultsView.isHidden = false
                self?.spinner.stopAnimating()
            }
        }

        viewModel.registerNoResultsHandler { [weak self] in
            DispatchQueue.main.async {
                self?.noResultsView.isHidden = false
                self?.resultsView.isHidden = true
                self?.spinner.stopAnimating()
            }
        }
    }
}

// MARK: - PublicMethods
extension RMSearchView {
    func presentKeyboard() {
        searchInputView.presentKeyboard()
    }

    func hideKeyboard() {
        searchInputView.hideKeyboard()
    }
}

// MARK: - RMSearchInputViewDelegate
extension RMSearchView: RMSearchInputViewDelegate {
    func rmSearchInputViewDidTapSearchKeyboardButton(_ inputView: RMSearchInputView) {
        viewModel.executeSearch()
    }

    func rmSearchInputView(_ inputView: RMSearchInputView, didChangeSearchText text: String) {
        viewModel.set(query: text)
    }

    func rmSearchInputView(_ inputView: RMSearchInputView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption) {
        delegate?.rmSearchView(self, didSelectOption: option)
    }
}

// MARK: - UICollectionViewDataSource
extension RMSearchView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.numberOfItemsInSection
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension RMSearchView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - RMSearchResultsViewDelegate
extension RMSearchView: RMSearchResultsViewDelegate {
    func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapLocationAt index: Int) {
        guard let locationModel = viewModel.locationSearchResult(at: index) else {
            return
        }
        delegate?.rmSearchView(self, didSelectLocation: locationModel)
    }

    func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapCharacterAt index: Int) {
        guard let characterModel = viewModel.characterSearchResult(at: index) else {
            return
        }
        delegate?.rmSearchView(self, didSelectCharacter: characterModel)
    }

    func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapEpisodeAt index: Int) {
        guard let episodeModel = viewModel.episodeSearchResult(at: index) else {
            return
        }
        delegate?.rmSearchView(self, didSelectEpisode: episodeModel)
    }
}

// MARK: - Constraints
private extension RMSearchView {
    private func addConstraints() {
        NSLayoutConstraint.activate([
            // Search input view
            searchInputView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            searchInputView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            searchInputView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            searchInputView.heightAnchor.constraint(
                equalToConstant: viewModel.config.type == .episode ? 55 : 100
            ),

            // No results
            noResultsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noResultsView.centerYAnchor.constraint(equalTo: centerYAnchor),
            noResultsView.widthAnchor.constraint(equalToConstant: 150),
            noResultsView.heightAnchor.constraint(equalToConstant: 150),

            // Results View
            resultsView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            resultsView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            resultsView.topAnchor.constraint(equalTo: searchInputView.bottomAnchor),
            resultsView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            // Spinner
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
}
