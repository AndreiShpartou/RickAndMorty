//
//  RMLocationViewViewModelProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 11/07/2024.
//

import Foundation

protocol RMLocationViewViewModelProtocol {
    var delegate: RMLocationViewViewModelDelegate? { get set }
    var shouldShowLoadMoreIndicator: Bool { get }
    var nextUrlString: String? { get }
    var cellViewModels: [RMLocationTableViewCellViewModelWrapper] { get }
    var isLoadingMoreLocations: Bool { get }

    func fetchLocations()
    func fetchAdditionalLocations()
    func fetchAdditionalLocationsWithDelay(_ delay: TimeInterval)
    func getLocation(at index: Int) -> RMLocationProtocol
}

protocol RMLocationViewViewModelDelegate: AnyObject {
    func didLoadInitialLocations()
    func didLoadMoreLocations()
}
