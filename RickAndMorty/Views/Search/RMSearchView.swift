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
}

final class RMSearchView: UIView {
    
    weak var delegate: RMSearchViewDelegate?
    
    let viewModel: RMSearchViewViewModel
    
    // MARK: - Subviews
    
    // SearchInputView(bar, selection buttons)
    private let searchInputView = RMSearchInputView()
    
    // No results view
    private let noResultsView = RMNoSearchResultsView()
    
    
    private let resultsView = RMSearchResultsView()
    
    // Results collectionView
    
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
        
        addSubviews(noResultsView, searchInputView, resultsView)
        searchInputView.configure(
            with: RMSearchInputViewViewModel(type: viewModel.config.type)
        )
        searchInputView.delegate = self
        
        resultsView.delegate = self
        
        
        setupHandlers()
        addConstraints()
    }
    
    private func setupHandlers() {
        
        viewModel.registerOptionChangeBlock { tuple in
            self.searchInputView.update(option: tuple.0, value: tuple.1)
        }
        
        viewModel.registerSearchResultHandler { [weak self] results in
            DispatchQueue.main.async {
                self?.resultsView.configure(with: results)
                self?.noResultsView.isHidden = true
                self?.resultsView.isHidden = false
            }
        }
        
        viewModel.registerNoResultsHandler { [weak self] in
            DispatchQueue.main.async {
                self?.noResultsView.isHidden = false
                self?.resultsView.isHidden = true
            }
        }
    }
}

// MARK: - PublicMethods
extension RMSearchView {
    public func presentKeyboard() {
        searchInputView.presentKeyboard()
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
        return 0
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
            resultsView.bottomAnchor.constraint(equalTo: bottomAnchor)
            
        ])
    }
}
