//
//  RMCharacterDetailsView.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 06/06/2024.
//

import UIKit

// View for single character info
final class RMCharacterDetailsView: UIView {

    weak var delegate: RMCharacterDetailsViewDelegate?
    private let collectionHandler: RMCharacterDetailsCollectionHandler

    private lazy var collectionView: UICollectionView = createCollectionView()
    private lazy var spinner: UIActivityIndicatorView = createSpinner()

    // MARK: - Init
    init(collectionHandler: RMCharacterDetailsCollectionHandler) {
        self.collectionHandler = collectionHandler
        super.init(frame: .zero)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - RMCharacterDetailsViewProtocol
extension RMCharacterDetailsView: RMCharacterDetailsViewProtocol {
    func didFetchCharactersDetails() {
        spinner.stopAnimating()
        collectionView.reloadData()
        collectionView.isHidden = false
        UIView.animate(
            withDuration: 0.3
        ) {
            self.collectionView.alpha = 1
        }
    }

    // MARK: - Layout
    func createPhotoSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 10,
            trailing: 0
        )

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(1.0) // .fractionalHeight(0.5)
            ),
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)

        return section
    }

    func createInfoSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(UIDevice.isPhone ? 0.5 : 0.25),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 2,
            leading: 2,
            bottom: 2,
            trailing: 2
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(150)
            ),
            subitems: UIDevice.isPhone ? [item, item] : [item, item, item, item]
        )

        let section = NSCollectionLayoutSection(group: group)

        return section
    }

    func createEpisodeSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 5,
            bottom: 10,
            trailing: 5
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(UIDevice.isPhone ? 0.8 : 0.4),
                heightDimension: .absolute(150)
            ),
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging

        return section
    }
}

// MARK: - Setup
extension RMCharacterDetailsView {
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
extension RMCharacterDetailsView {
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let strongSelf = self else {
                return nil
            }

            return strongSelf.delegate?.rmCharacterDetailsView(strongSelf, createLayoutFor: sectionIndex)
        }

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.showsVerticalScrollIndicator = false

        collectionView.register(
            RMCharacterPhotoCollectionViewCell.self,
            forCellWithReuseIdentifier: RMCharacterPhotoCollectionViewCell.cellIdentifier
        )
        collectionView.register(
            RMCharacterInfoCollectionViewCell.self,
            forCellWithReuseIdentifier: RMCharacterInfoCollectionViewCell.cellIdentifier
        )
        collectionView.register(
            RMEpisodeCollectionViewCell.self,
            forCellWithReuseIdentifier: RMEpisodeCollectionViewCell.cellIdentifier
        )

        return collectionView
    }

    private func createSpinner() -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true

        return spinner
    }
}

// MARK: - Constraints
extension RMCharacterDetailsView {
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
