//
//  RMCharacterDetailsCollectionViewHandler.swift.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 07/07/2024.
//

import Foundation

import UIKit

class RMCharacterDetailsCollectionViewHandler: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    private let viewModel: RMCharacterDetailViewViewModelProtocol

    init(viewModel: RMCharacterDetailViewViewModelProtocol) {
        self.viewModel = viewModel
    }
}

// MARK: - CollectionView DataSource
extension RMCharacterDetailsCollectionViewHandler {
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
                withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? RMCharacterEpisodeCollectionViewCell else {
                fatalError("Unable to define cell for episode")
            }
            cell.configure(with: viewModels[indexPath.row])

            return cell
        }
    }
}

// MARK: - CollectionView Delegation
extension RMCharacterDetailsCollectionViewHandler {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionType = viewModel.sections[indexPath.section]
        if case .episodes = sectionType {
            let selection = viewModel.episodes[indexPath.row]
            viewModel.delegate?.didSelectEpisode(selection)
        }
    }
}
