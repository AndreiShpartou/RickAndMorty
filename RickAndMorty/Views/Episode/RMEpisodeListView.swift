//
//  RMEpisodeListView.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 09/06/2024.
//

import UIKit

// View that handles showing list of episodes, loader, etc.
// MARK: - View Implementation
final class RMEpisodeListView: UIView {

    private let collectionHandler: RMEpisodeCollectionHandler

    private lazy var spinner: UIActivityIndicatorView = .createSpinner()
    private lazy var collectionView: UICollectionView = createCollectionView()

    // MARK: - Init
    init(collectionHandler: RMEpisodeCollectionHandler) {
        self.collectionHandler = collectionHandler
        super.init(frame: .zero)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - RMEpisodeListViewProtocol
extension RMEpisodeListView: RMEpisodeListViewProtocol {
    func setNilValueForScrollOffset() {
        collectionView.setContentOffset(.zero, animated: true)
    }

    func orientationDidChange() {
        collectionView.collectionViewLayout.invalidateLayout()
    }

    func didLoadInitialEpisodes() {
        spinner.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData() // Initial fetch of characters
        UIView.animate(withDuration: 0.4) {
            self.collectionView.alpha = 1
        }
    }

    func didLoadMoreEpisodes(with newIndexPath: [IndexPath]) {
        collectionView.performBatchUpdates { [weak self] in
            self?.collectionView.insertItems(at: newIndexPath)
        }
    }
}

// MARK: - Setup
extension RMEpisodeListView {
    private func setupView() {
        backgroundColor = .systemBackground

        addSubviews(collectionView, spinner)
        setupSubviews()

        addConstraints()
    }

    private func setupSubviews() {
        setupCollectionView()
        spinner.startAnimating()
    }

    private func setupCollectionView() {
        collectionView.dataSource = collectionHandler
        collectionView.delegate = collectionHandler
    }
}

// MARK: - Helpers
extension RMEpisodeListView {
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.register(
            RMEpisodeCollectionViewCell.self,
            forCellWithReuseIdentifier: RMEpisodeCollectionViewCell.cellIdentifier
        )
        collectionView.register(
            RMFooterLoadingCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier
        )

        return collectionView
    }
}

// MARK: - Constraints
extension RMEpisodeListView {
    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),

            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
