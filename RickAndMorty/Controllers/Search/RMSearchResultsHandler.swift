//
//  RMSearchResultsHandler.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 12/07/2024.
//
import UIKit

protocol RMSearchResultsHandlerDelegate: AnyObject {
}

final class RMSearchResultsHandler: NSObject {

    weak var delegate: RMSearchResultsHandlerDelegate?

    private var viewModel: RMSearchResultsViewViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }

            switch viewModel.results {
            case .characters(let array):
                collectionViewCellViewModels = array
            case .episodes(let array):
                collectionViewCellViewModels = array
            case .locations(let array):
                locationTableViewCellViewModels = array
            }
        }
    }
    // TableView ViewModels
    private var locationTableViewCellViewModels: [RMLocationTableViewCellViewModelWrapper] = []
    // CollectionView ViewModels
    private var collectionViewCellViewModels: [any Hashable] = []
}

extension RMSearchResultsHandler {
    func configure(with viewModel: RMSearchResultsViewViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - UITableViewDataSource
extension RMSearchResultsHandler: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationTableViewCellViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RMLocationTableViewCell.cellIdentifier,
            for: indexPath
        ) as? RMLocationTableViewCell else {
            fatalError("Failed to dequeue RMLocationTableViewCell")
        }
        cell.configure(with: locationTableViewCellViewModels[indexPath.row])

        return cell
    }
}

// MARK: - UITableViewDelegate
extension RMSearchResultsHandler: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

//        delegate?.rmSearchResultsView(self, didTapLocationAt: indexPath.row)
    }
}

// MARK: - UICollectionViewDataSource
extension RMSearchResultsHandler: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewCellViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Character | Episode
        let viewModel = collectionViewCellViewModels[indexPath.row]
        if let characterViewModel = viewModel as? RMCharacterCollectionViewCellViewModelWrapper {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? RMCharacterCollectionViewCell else {
                fatalError("Failed to determine cell type")
            }

            cell.configure(with: characterViewModel)

            return cell
        } else if let episodeViewModel = viewModel as? RMEpisodeCollectionViewCellViewModelWrapper {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMEpisodeCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? RMEpisodeCollectionViewCell else {
                fatalError("Failed to determine cell type")
            }

            cell.configure(with: episodeViewModel)

            return cell
        } else {
            fatalError("Failed to determine cell type")
        }
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

        if let viewModel = viewModel,
           viewModel.shouldShowLoadMoreIndicator {
            footer.startAnimating()
        }

        return footer
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let viewModel = viewModel,
            viewModel.shouldShowLoadMoreIndicator else {
            return .zero
        }

        return CGSize(
            width: collectionView.frame.width,
            height: 100
        )
    }
}

// MARK: - UICollectionViewDelegate
extension RMSearchResultsHandler: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        guard let viewModel = viewModel else {
            return
        }
//        switch viewModel.results {
//        case .characters:
//            delegate?.rmSearchResultsView(self, didTapCharacterAt: indexPath.row)
//        case .episodes:
//            delegate?.rmSearchResultsView(self, didTapEpisodeAt: indexPath.row)
//        case .locations:
//            break
//        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension RMSearchResultsHandler: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Character | Episode
        let viewModel = collectionViewCellViewModels[indexPath.row]
        let bounds = collectionView.bounds
        let isLandscapeMultiplier = UIDevice.isLandscape ? 0.45 : 1
        if viewModel is RMCharacterCollectionViewCellViewModelWrapper {
            let width = UIDevice.isPhone ? ((bounds.width - 30) / 2) * isLandscapeMultiplier : (bounds.width - 60) / 4
            return CGSize(
                width: width,
                height: width * 1.5
            )
        } else if viewModel is RMEpisodeCollectionViewCellViewModelWrapper {
            let width = UIDevice.isPhone ? (bounds.width - 20) * isLandscapeMultiplier : (bounds.width - 30) / 2
            return CGSize(
                width: width,
                height: 105
            )
        } else {
            return .zero
        }
    }
}

// MARK: - UIScrollViewDelegate
extension RMSearchResultsHandler: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !locationTableViewCellViewModels.isEmpty {
            handleLocationPagination(scrollView)
        } else if !collectionViewCellViewModels.isEmpty {
            handleCharacterOrEpisodePagination(scrollView)
        }
    }

    // MARK: - Pagination
    private func handleCharacterOrEpisodePagination(_ scrollView: UIScrollView) {
        guard let viewModel = viewModel,
              viewModel.shouldShowLoadMoreIndicator,
              !viewModel.isLoadingMoreResults
        else {
            return
        }

        let offset = scrollView.contentOffset.y
        let totalContentHeight = scrollView.contentSize.height
        let totalScrollViewFixedHeight = scrollView.frame.size.height

        if totalContentHeight != 0, offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
//            viewModel.fetchAdditionalResultsWithDelay(0.1) { [weak self] newResults in
//                guard let strongSelf = self else {
//                    return
//                }
//
//                let originalCount = strongSelf.collectionViewCellViewModels.count
//                let newCount = (newResults.count - originalCount)
//                let total = originalCount + newCount
//                let startingIndex = total - newCount
//                let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex + newCount)).compactMap {
//                    return IndexPath(row: $0, section: 0)
//                }
//                strongSelf.collectionViewCellViewModels = newResults
//                strongSelf.collectionView.insertItems(at: indexPathsToAdd)
//            }
        }
    }

    private func handleLocationPagination(_ scrollView: UIScrollView) {
        guard let viewModel = viewModel,
              viewModel.shouldShowLoadMoreIndicator,
              !viewModel.isLoadingMoreResults
        else {
            return
        }

        let offset = scrollView.contentOffset.y
        let totalContentHeight = scrollView.contentSize.height
        let totalScrollViewFixedHeight = scrollView.frame.size.height

        if totalContentHeight != 0, offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
//            showTableLoadingIndicator()
//            viewModel.fetchAdditionalLocationsWithDelay(0.1) { [weak self] newResults in
//                self?.tableView.tableFooterView = nil
//                self?.locationTableViewCellViewModels = newResults
//                self?.tableView.reloadData()
//            }
        }
    }

    private func showTableLoadingIndicator() {
        let footerView = RMTableLoadingFooterView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        tableView.tableFooterView = footerView
    }
}
