//
//  RMLocationDetailsView.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 12/06/2024.
//

import UIKit

final class RMLocationDetailsView: UIView {

    weak var delegate: RMLocationDetailsViewDelegate?
    private let collectionHandler: RMLocationDetailsCollectionHandler

    private lazy var collectionView: UICollectionView = createCollectionView()
    private lazy var spinner: UIActivityIndicatorView = createActivityIndicator()

    // MARK: - Init
    init(collectionHandler: RMLocationDetailsCollectionHandler) {
        self.collectionHandler = collectionHandler
        super.init(frame: .zero)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - RMLocationDetailsViewProtocol
extension RMLocationDetailsView: RMLocationDetailsViewProtocol {
    func didFetchLocationDetails() {
        spinner.stopAnimating()
        self.collectionView.reloadData()
        self.collectionView.isHidden = false
        UIView.animate(
            withDuration: 0.3
        ) {
            self.collectionView.alpha = 1
        }
    }

    // MARK: - Layout
    func createInfoLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )

        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(80)
            ),
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)

        return section
    }

    func createCharacterLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(UIDevice.isPhone && !UIDevice.isLandscape ? 0.5 : 0.25),
                heightDimension: .fractionalHeight(1)
            )
        )

        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(UIDevice.isPhone ? 260 : 320)
            ),
            subitems: UIDevice.isPhone ? [item, item] : [item, item, item, item]
        )

        let section = NSCollectionLayoutSection(group: group)

        return section
    }
}

// MARK: - Setup
extension RMLocationDetailsView {
    private func setupView() {
        backgroundColor = .systemBackground

        addSubviews(collectionView, spinner)
        spinner.startAnimating()
        setupCollectionView()

        addConstraints()
    }

    private func setupCollectionView() {
        collectionView.dataSource = collectionHandler
        collectionView.delegate = collectionHandler
    }
}

// MARK: - Helpers
extension RMLocationDetailsView {
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true

        return spinner
    }

    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let strongSelf = self else {
                return nil
            }

            return strongSelf.delegate?.rmLocationDetailsView(strongSelf, createLayoutFor: sectionIndex)
        }
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.register(
            RMEpisodeInfoCollectionViewCell.self,
            forCellWithReuseIdentifier: RMEpisodeInfoCollectionViewCell.cellIdentifier
        )
        collectionView.register(
            RMCharacterCollectionViewCell.self,
            forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier
        )

        return collectionView
    }
}

// MARK: - Constraints
extension RMLocationDetailsView {
    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.widthAnchor.constraint(equalToConstant: 100),

            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
