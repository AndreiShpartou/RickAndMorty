//
//  RMEpisodeDetailsCollectionHandler.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 10/07/2024.
//

import UIKit

protocol RMEpisodeDetailsCollectionHandlerDelegate: AnyObject {
    func didSelectItemAt(_ section: Int, _ index: Int)
}

final class RMEpisodeDetailsCollectionHandler: NSObject {
    weak var delegate: RMEpisodeDetailsCollectionHandlerDelegate?

    private let viewModel: RMEpisodeDetailsViewViewModelProtocol

    // MARK: - Init
    init(viewModel: RMEpisodeDetailsViewViewModelProtocol) {
        self.viewModel = viewModel
    }
}

// MARK: - CollectionView DataSource
extension RMEpisodeDetailsCollectionHandler: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = viewModel.sections[section]
        switch sectionType {
        case .episodeInfo(let viewModels):
            return viewModels.count
        case .characters(let viewModels):
            return viewModels.count
        default:
            fatalError("Unacceptable section type!")
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = viewModel.sections[indexPath.section]
        switch sectionType {
        case .episodeInfo(let viewModels):
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
        default:
            fatalError("Unacceptable section type!")
        }
    }
}

// MARK: - CollectionView Delegation
extension RMEpisodeDetailsCollectionHandler: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        delegate?.didSelectItemAt(indexPath.section, indexPath.row)
    }
}
