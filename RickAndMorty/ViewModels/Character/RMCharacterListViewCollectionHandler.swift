//
//  RMCharacterListViewCollectionHandler.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 04/07/2024.
//
import UIKit

final class RMCharacterListViewCollectionHandler: NSObject {
    private let viewModel: RMCharacterListViewViewModelProtocol

    // MARK: - Init
    init(viewModel: RMCharacterListViewViewModelProtocol) {
        self.viewModel = viewModel
    }
}

// MARK: - CollectionView DataSource
extension RMCharacterListViewCollectionHandler: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.cellViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? RMCharacterCollectionViewCell else {
            fatalError("Unsupported cell")
        }

        cell.configure(with: viewModel.cellViewModels[indexPath.row])

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter,
              let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier,
                for: indexPath
              ) as? RMFooterLoadingCollectionReusableView else {
            fatalError("Unsupported")
        }

        footer.startAnimating()

        return footer
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard viewModel.shouldShowLoadMoreIndicator else {
            return .zero
        }

        return CGSize(
            width: collectionView.frame.width,
            height: 100
        )
    }
}
// MARK: - CollectionView Delegation
extension RMCharacterListViewCollectionHandler: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let bounds = collectionView.bounds
        let width: CGFloat
        let isLandscapeMultiplier = UIDevice.isLandscape ? 0.45 : 1
        if UIDevice.isPhone {
            width = (bounds.width - 30) * isLandscapeMultiplier / 2
        } else {
            // Mac or iPad
            width = (bounds.width - 50) / 4
        }

        return CGSize(
            width: width,
            height: width * 1.5
        )
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let character = viewModel.getCharacter(at: indexPath.row)
        viewModel.delegate?.didSelectCharacter(character)
    }
}

// MARK: - UIScrollViewDelegate
extension RMCharacterListViewCollectionHandler: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard viewModel.shouldShowLoadMoreIndicator,
              !viewModel.isLoadingMoreCharacters,
              !viewModel.cellViewModels.isEmpty,
              let nextUrlString = viewModel.nextUrlString,
              let url = URL(string: nextUrlString) else {
            return
        }

        let offset = scrollView.contentOffset.y
        let totalContentHeight = scrollView.contentSize.height
        let totalScrollViewFixedHeight = scrollView.frame.size.height

        if totalContentHeight != 0, offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
            viewModel.fetchAdditionalCharactersWithDelay(0.1, url: url)
        }
    }
}
