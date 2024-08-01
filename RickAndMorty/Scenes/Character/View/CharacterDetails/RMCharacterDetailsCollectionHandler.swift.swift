//
//  RMCharacterDetailsCollectionHandler.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 07/07/2024.
//

import Foundation

import UIKit

protocol RMCharacterDetailsCollectionHandlerDelegate: AnyObject {
    func didSelectItemAt(_ section: Int, _ index: Int)
}

class RMCharacterDetailsCollectionHandler: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {

    weak var delegate: RMCharacterDetailsCollectionHandlerDelegate?

    private let viewModel: RMCharacterDetailsViewViewModelProtocol

    init(viewModel: RMCharacterDetailsViewViewModelProtocol) {
        self.viewModel = viewModel
    }
}

// MARK: - CollectionView DataSource
extension RMCharacterDetailsCollectionHandler {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = viewModel.sections[section]
        switch sectionType {
        case .photo:
            return Constants.oneItemInSection
        case .characterInfo(let viewModels):
            return viewModels.count
        case .episodes(let viewModels):
            return viewModels.count
        default:
            fatalError("Unacceptable section type!")
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = viewModel.sections[indexPath.section]
        switch sectionType {
        case .photo(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterPhotoCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? RMCharacterPhotoCollectionViewCell else {
                fatalError("Unable to define cell for photo")
            }
            cell.configure(with: viewModel)

            return cell
        case .characterInfo(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterInfoCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? RMCharacterInfoCollectionViewCell else {
                fatalError("Unable to define cell for info")
            }
            cell.configure(with: viewModels[indexPath.row])

            return cell
        case .episodes(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMEpisodeCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? RMEpisodeCollectionViewCell else {
                fatalError("Unable to define cell for episode")
            }
            cell.configure(with: viewModels[indexPath.row])

            return cell
        default:
            fatalError("Unacceptable section type!")
        }
    }
}

// MARK: - CollectionView Delegation
extension RMCharacterDetailsCollectionHandler {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectItemAt(indexPath.section, indexPath.row)
    }
}
