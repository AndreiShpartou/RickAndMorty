//
//  RMSearchView.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 13/06/2024.
//

import UIKit

final class RMSearchView: UIView {
    
    let viewModel: RMSearchViewViewModel
    
    // MARK: - Subviews
    
    // SearchInputView(bar, selection buttons)
    private let searchInputView = RMSearchInputView()
    
    // No results view
    private let noResultsView = RMNoSearchResultsView()
    
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
        
        addSubviews(noResultsView, searchInputView)
        searchInputView.configure(
            with: RMSearchInputViewViewModel(type: viewModel.config.type)
        )
        
        addConstraints()
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

// MARK: - Constraints
private extension RMSearchView {
    private func addConstraints() {
        NSLayoutConstraint.activate([
            // Search input view
            searchInputView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            searchInputView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            searchInputView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            searchInputView.heightAnchor.constraint(equalToConstant: 150),
            
            // No results
            noResultsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noResultsView.centerYAnchor.constraint(equalTo: centerYAnchor),
            noResultsView.widthAnchor.constraint(equalToConstant: 150),
            noResultsView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
}
