//
//  RMLocationDetailsCollectionHandler.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 11/07/2024.
//
import UIKit

protocol RMLocationDetailsCollectionHandlerDelegate: AnyObject {
    func didSelectItemAt(_ section: Int, _ index: Int)
}

final class RMLocationDetailsCollectionHandler: NSObject {
    weak var delegate: RMLocationDetailsCollectionHandlerDelegate?

    private let viewModel: RMLocationDetailsViewViewModelProtocol

    // MARK: - Init
    init(viewModel: RMLocationDetailsViewViewModelProtocol) {
        self.viewModel = viewModel
    }
}

// MARK: - CollectionView DataSource
extension RMLocationDetailsCollectionHandler: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = viewModel.sections[section]
        switch sectionType {
        case .locationInfo(let viewModels):
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
        case .locationInfo(let viewModels):
            let cellViewModel = viewModels[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMEpisodeInfoCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? RMEpisodeInfoCollectionViewCell else {
                fatalError("Unable to define cell for episode info")
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
extension RMLocationDetailsCollectionHandler: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        delegate?.didSelectItemAt(indexPath.section, indexPath.row)
    }
}
