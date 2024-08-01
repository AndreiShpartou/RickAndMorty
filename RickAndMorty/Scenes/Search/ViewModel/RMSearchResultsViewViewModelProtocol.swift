//
//  RMSearchResultsViewViewModelProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 13/07/2024.
//

import Foundation

protocol RMSearchResultsViewViewModelProtocol: AnyObject {
    var shouldShowLoadMoreIndicator: Bool { get }
    var isLoadingMoreResults: Bool { get }
    var results: RMSearchResultsType { get }

    func registerLoadPageHandler(handler: @escaping ([Codable]) -> Void)
    func fetchAdditionalResults(completion: @escaping ([Any]) -> Void)
    func fetchAdditionalResultsWithDelay(
        _ delay: TimeInterval,
        completion: @escaping ([Any]) -> Void
    )
}
