//
//  RMSearchResultsViewProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 12/07/2024.
//
import UIKit

protocol RMSearchResultsViewProtocol: UIView {
    func orientationDidChange(_ notification: Notification)
    func configure(with viewModel: RMSearchResultsViewViewModelProtocol)
    func didLoadMoreResults(with newIndexPath: [IndexPath])
    func showLoadingIndicator()
}
