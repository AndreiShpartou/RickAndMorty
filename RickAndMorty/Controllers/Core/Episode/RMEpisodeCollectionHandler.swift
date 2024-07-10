//
//  RMEpisodeCollectionHandler.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 10/07/2024.
//
import UIKit

protocol RMEpisodeCollectionHandlerDelegate: AnyObject {
    func didSelectItemAt(_ index: Int)
}

final class RMEpisodeCollectionHandler: NSObject {
    weak var delegate: RMEpisodeCollectionHandlerDelegate?

    private let viewModel: RMEpisodeListViewViewModelProtocol

    // MARK: - Init
    init(viewModel: RMEpisodeListViewViewModelProtocol) {
        self.viewModel = viewModel
    }
}

// MARK: - CollectionView DataSource
extension RMEpisodeCollectionHandler: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.cellViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RMEpisodeCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? RMEpisodeCollectionViewCell else {
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

// MARK: - UICollectionViewDelegateFlowLayout
extension RMEpisodeCollectionHandler: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let width = bounds.width - 20
        return CGSize(
            width: width,
            height: 100
        )
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.didSelectItemAt(indexPath.row)
    }
}

// MARK: - UIScrollViewDelegate
extension RMEpisodeCollectionHandler: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard viewModel.shouldShowLoadMoreIndicator,
              !viewModel.isLoadingMoreEpisodes,
              !viewModel.cellViewModels.isEmpty,
              let nextUrlString = viewModel.nextUrlString,
              let url = URL(string: nextUrlString) else {
            return
        }

        let offset = scrollView.contentOffset.y
        let totalContentHeight = scrollView.contentSize.height
        let totalScrollViewFixedHeight = scrollView.frame.size.height

        if totalContentHeight != 0, offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
            viewModel.fetchAdditionalEpisodesWithDelay(0.1, url: url)
        }
    }
}
