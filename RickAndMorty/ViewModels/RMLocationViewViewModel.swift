//
//  RMLocationViewViewModel.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 12/06/2024.
//

import Foundation

final class RMLocationViewViewModel {
    // MARK: - Properties
    private var locations: [RMLocation] = []
    
    // Location response info
    // Will contain next url, if present
    
    private var cellViewModels: [String] = []
    
    private var hasMoreResults: Bool {
        return false
    }
    
    // MARK: - Init
    init() {}
    
    // MARK: - PrivateMethods

}

// MARK: - PublicMethods
extension RMLocationViewViewModel {
    public func fetchLocations() {
        RMService.shared.execute(
            .listLocationsRequests,
            expecting: String.self) { result in
                switch result {
                case .success(let model):
                    print(String(describing: model))
                case .failure(let failure):
                    print(String(describing: failure))
                }
            }
    }
}
