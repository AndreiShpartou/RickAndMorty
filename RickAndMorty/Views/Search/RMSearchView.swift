//
//  RMSearchView.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 13/06/2024.
//

import UIKit

// MARK: - View Implementation
final class RMSearchView: UIView {

    private let configType: RMConfigType

    private lazy var spinner: UIActivityIndicatorView = .createSpinner()
    // SearchInputView(bar, selection buttons)
    private let searchInputView: RMSearchInputViewProtocol
    // No results view
    private let noResultsView: RMNoSearchResultsView
    // Results collectionView / TableView
    private var resultsView: RMSearchResultsViewProtocol

    // MARK: - Init
    init(
        configType: RMConfigType,
        searchInputView: RMSearchInputViewProtocol,
        resultsView: RMSearchResultsViewProtocol,
        noResultsView: RMNoSearchResultsView = RMNoSearchResultsView()
    ) {
        self.configType = configType
        self.searchInputView = searchInputView
        self.noResultsView = noResultsView
        self.resultsView = resultsView

        super.init(frame: .zero)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - RMSearchViewProtocol
extension RMSearchView: RMSearchViewProtocol {
    func beginSearchProcess() {
        spinner.startAnimating()
    }

    func showSearchResults() {
        noResultsView.isHidden = true
        resultsView.isHidden = false
        spinner.stopAnimating()
    }

    func showNoResults() {
        noResultsView.isHidden = false
        resultsView.isHidden = true
        spinner.stopAnimating()
    }
}

// MARK: - Setup
extension RMSearchView {
    private func setupView() {
        backgroundColor = .systemBackground

        addSubviews(noResultsView, searchInputView, resultsView, spinner)
        addConstraints()
    }
}

// MARK: - Constraints
extension RMSearchView {
    private func addConstraints() {
        NSLayoutConstraint.activate([
            // Search input view
            searchInputView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            searchInputView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            searchInputView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            searchInputView.heightAnchor.constraint(
                equalToConstant: configType == .episode ? 55 : 100
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
