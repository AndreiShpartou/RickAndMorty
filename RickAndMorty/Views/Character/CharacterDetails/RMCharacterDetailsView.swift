//
//  RMCharacterDetailsView.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 06/06/2024.
//

import UIKit

// View for single character info
final class RMCharacterDetailsView: UIView, RMCharacterDetailsViewProtocol {

    weak var delegate: RMCharacterDetailsViewDelegate?

    private(set) lazy var collectionView: UICollectionView = createCollectionView()

    private let viewModel: RMCharacterDetailViewViewModelProtocol
    private let collectionHandler: RMCharacterDetailsCollectionViewHandler
    private lazy var spinner: UIActivityIndicatorView = createSpinner()

    // MARK: - Init
    init(frame: CGRect, viewModel: RMCharacterDetailViewViewModelProtocol) {
        self.viewModel = viewModel
        self.collectionHandler = RMCharacterDetailsCollectionViewHandler(viewModel: viewModel)
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup
extension RMCharacterDetailsView {
    private func setupView() {
        backgroundColor = .systemBackground

        addSubviews(collectionView, spinner)
        viewModel.delegate = self
        setupCollectionView()

        addConstraints()
    }

    private func createSection(for sectionIndex: Int) -> NSCollectionLayoutSection {
        let sectionTypes = viewModel.sections
        switch sectionTypes[sectionIndex] {
        case .photo:
            return viewModel.createPhotoSectionLayout()
        case .characterInfo:
            return viewModel.createInfoSectionLayout()
        case .episodes:
            return viewModel.createEpisodeSectionLayout()
        }
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
            return self?.createSection(for: sectionIndex)
        }

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )

        collectionView.register(
            RMCharacterPhotoCollectionViewCell.self,
            forCellWithReuseIdentifier: RMCharacterPhotoCollectionViewCell.cellIdentifier
        )
        collectionView.register(
            RMCharacterInfoCollectionViewCell.self,
            forCellWithReuseIdentifier: RMCharacterInfoCollectionViewCell.cellIdentifier
        )
        collectionView.register(
            RMCharacterEpisodeCollectionViewCell.self,
            forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier
        )

        return collectionView
    }

    private func createSpinner() -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true

        return spinner
    }
}

// MARK: - RMCharacterDetailViewViewModelDelegate
extension RMCharacterDetailsView: RMCharacterDetailViewViewModelDelegate {
    func didSelectEpisode(_ episodeStringURL: String) {
        delegate?.rmCharacterListView(self, didSelectEpisode: episodeStringURL)
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
