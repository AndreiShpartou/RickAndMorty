//
//  RMSearchResultsViewViewModelProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 13/07/2024.
//

import Foundation

protocol RMSearchResultsViewViewModelProtocol {
    var shouldShowLoadMoreIndicator: Bool { get }
    var isLoadingMoreResults: Bool { get }
    var results: RMSearchResultsType { get }

    func registerLoadPageHandler(handler: @escaping ([Codable]) -> Void)
    func fetchAdditionalResults(completion: @escaping ([any Hashable]) -> Void)
    func fetchAdditionalResultsWithDelay(
        _ delay: TimeInterval,
        completion: @escaping ([any Hashable]) -> Void
    )
}
