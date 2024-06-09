//
//  RMEpisodeDetail.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 09/06/2024.
//

import UIKit

final class RMEpisodeDetailView: UIView {
    private var viewModel: RMEpisodeDetailViewViewModel?
    
    private lazy var collectionView: UICollectionView = createCollectionView()
    private lazy var spinner: UIActivityIndicatorView = createActivityIndicator()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Create View elements
    private func createCollectionView() -> UICollectionView {
        return UICollectionView()
    }
    
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView()
        return spinner
    }
    
    // MARK: - SetupView
    private func setupView() {
        backgroundColor = .systemBackground
        
    }
    
}

// MARK: - PublicMethods
extension RMEpisodeDetailView {
    public func configure(with viewModel: RMEpisodeDetailViewViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - Constraints
private extension RMEpisodeDetailView {
    private func addConstraints() {
        NSLayoutConstraint.activate([
            
        ])
    }
}
