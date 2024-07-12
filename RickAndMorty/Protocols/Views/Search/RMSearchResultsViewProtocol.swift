//
//  RMSearchResultsViewProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 12/07/2024.
//
import UIKit

protocol RMSearchResultsViewProtocol: UIView {
    var delegate: RMSearchResultsViewDelegate? { get set }

    func orientationDidChange(_ notification: Notification)
    func configure(with viewModel: RMSearchResultsViewViewModel)
}

protocol RMSearchResultsViewDelegate: AnyObject {
    func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapLocationAt index: Int)

    func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapCharacterAt index: Int)

    func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapEpisodeAt index: Int)
}
