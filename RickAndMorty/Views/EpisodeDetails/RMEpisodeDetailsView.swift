//
//  RMEpisodeDetailsView.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 09/06/2024.
//

import UIKit

protocol RMEpisodeDetailsViewDelegate: AnyObject {
    func rmEpisodeDetailView(
        _ detailView: RMEpisodeDetailsView,
        didSelect character: RMCharacter
    )
}

final class RMEpisodeDetailsView: UIView {
    weak var delegate: RMEpisodeDetailsViewDelegate?

    private var viewModel: RMEpisodeDetailViewViewModel? {
        didSet {
            spinner.stopAnimating()
            self.collectionView.reloadData()
            self.collectionView.isHidden = false
            UIView.animate(
                withDuration: 0.3
            ) {
                    self.collectionView.alpha = 1
            }
        }
    }

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

    // MARK: - SetupView
    private func setupView() {
        backgroundColor = .systemBackground

        addSubviews(collectionView, spinner)
        addConstraints()

        spinner.startAnimating()
    }
}

// MARK: - PublicMethods
extension RMEpisodeDetailsView {
    func configure(with viewModel: RMEpisodeDetailViewViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - ViewElements
private extension RMEpisodeDetailsView {

    private func createActivityIndicator() -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        return spinner
    }

    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { section, _ in
            return self.createLayout(for: section)
        }
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.delegate = self
        collectionView.dataSource = self
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

    private func createLayout(for section: Int) -> NSCollectionLayoutSection {
        guard let sections = viewModel?.cellViewModels else {
            return createInfoLayout()
        }

        switch sections[section] {
        case .information:
            return createInfoLayout()
        case .characters:
            return createCharacterLayout()
        }
    }

    private func createInfoLayout() -> NSCollectionLayoutSection {
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

    private func createCharacterLayout() -> NSCollectionLayoutSection {
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

// MARK: - UICollectionViewDataSource
extension RMEpisodeDetailsView: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.cellViewModels.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = viewModel?.cellViewModels else {
            return Constants.numberOfItemsInSection
        }

        let sectionType = sections[section]
        switch sectionType {
        case .information(let viewModels):
            return viewModels.count
        case .characters(let viewModels):
            return viewModels.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let sections = viewModel?.cellViewModels else {
            fatalError("Unable to define ViewModel")
        }

        let sectionType = sections[indexPath.section]
        switch sectionType {
        case .information(let viewModels):
            let cellViewModel = viewModels[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMEpisodeInfoCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? RMEpisodeInfoCollectionViewCell else {
                fatalError("Unable to define cell for info")
            }
            cell.configure(with: cellViewModel)
            return cell
        case .characters(let viewModels):
            let cellViewModel = viewModels[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? RMCharacterCollectionViewCell else {
                fatalError("Unable to define cell for character")
            }
            cell.configure(with: cellViewModel)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension RMEpisodeDetailsView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        guard let viewModel = viewModel else {
            return
        }
        let sections = viewModel.cellViewModels
        let sectionType = sections[indexPath.section]

        switch sectionType {
        case .information:
            break
        case .characters:
            guard let character = viewModel.character(at: indexPath.row) else {
                return
            }
            delegate?.rmEpisodeDetailView(self, didSelect: character)
        }
    }
}

// MARK: - Constraints
private extension RMEpisodeDetailsView {
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
