//
//  RMLocationTableViewHandler.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 11/07/2024.
//
import UIKit

protocol RMLocationTableViewHandlerDelegate: AnyObject {
    func didSelectItemAt(_ index: Int)
    func showLoadingIndicator()
}

final class RMLocationTableViewHandler: NSObject {
    weak var delegate: RMLocationTableViewHandlerDelegate?

    private let viewModel: RMLocationViewViewModelProtocol

    // MARK: - Init
    init(viewModel: RMLocationViewViewModelProtocol) {
        self.viewModel = viewModel
    }
}

// MARK: - TableViewDataSource
extension RMLocationTableViewHandler: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cellViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModels = viewModel.cellViewModels
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "RMLocationTableViewCell",
            for: indexPath
        ) as? RMLocationTableViewCell else {
            fatalError("Unable to define cell for location")
        }

        let cellViewModel = cellViewModels[indexPath.row]
        cell.configure(with: cellViewModel)

        return cell
    }
}

// MARK: - TableViewDelegate
extension RMLocationTableViewHandler: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didSelectItemAt(indexPath.row)
    }
}

// MARK: - UIScrollViewDelegate
extension RMLocationTableViewHandler: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard viewModel.shouldShowLoadMoreIndicator,
              !viewModel.isLoadingMoreLocations,
              !viewModel.cellViewModels.isEmpty
        else {
            return
        }

        let offset = scrollView.contentOffset.y
        let totalContentHeight = scrollView.contentSize.height
        let totalScrollViewFixedHeight = scrollView.frame.size.height

        if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
            showLoadingIndicator()
            viewModel.fetchAdditionalLocationsWithDelay(0.1)
        }
    }

    private func showLoadingIndicator() {
        delegate?.showLoadingIndicator()
    }
}
