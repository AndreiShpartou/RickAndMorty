//
//  RMEpisodeListViewViewModelProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 10/07/2024.
//

import Foundation

protocol RMEpisodeListViewViewModelProtocol: AnyObject {
    var delegate: RMEpisodeListViewViewModelDelegate? { get set }
    var shouldShowLoadMoreIndicator: Bool { get }
    var nextUrlString: String? { get }
    var cellViewModels: [RMEpisodeCollectionViewCellViewModelWrapper] { get }
    var isLoadingMoreEpisodes: Bool { get }

    func fetchEpisodes()
    func fetchAdditionalEpisodes()
    func fetchAdditionalEpisodesWithDelay(_ delay: TimeInterval)
    func getEpisode(at index: Int) -> RMEpisodeProtocol
}

protocol RMEpisodeListViewViewModelDelegate: AnyObject {
    func didLoadInitialEpisodes()
    func didLoadMoreEpisodes(with newIndexPath: [IndexPath])
}
