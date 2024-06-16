//
//  RMLocationViewViewModel.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 12/06/2024.
//

import Foundation

protocol RMLocationViewViewModelDelegate: AnyObject {
    func didFetchInitialLocations()
}

final class RMLocationViewViewModel {
    // MARK: - Properties
    public weak var delegate: RMLocationViewViewModelDelegate?
    
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
    
    public private(set) var cellViewModels: [RMLocationTableViewCellViewModel] = []
    
    public var isLoadingMoreLocations = false
    
    private var locations: [RMLocation] = [] {
        didSet {
            for location in locations {
                let cellViewModel = RMLocationTableViewCellViewModel(
                    location: location
                )
                if !cellViewModels.contains(cellViewModel) {
                    cellViewModels.append(cellViewModel)
                }
            }
        }
    }
    
    // Location response info
    // Will contain next url, if present
    private var apiInfo: RMGetAllLocationsResponse.Info?
    
    private var hasMoreResults: Bool {
        return false
    }
    
    private var didLoadMoreLocationHandler: (() -> Void)?
    
    // MARK: - Init
    init() {}
    
    // MARK: - PrivateMethods

}

// MARK: - PublicMethods
extension RMLocationViewViewModel {
    
    public func registerDidLoadMoreLocation(with block: @escaping () -> Void) {
        didLoadMoreLocationHandler = block
    }
    
    public func location(at index: Int) -> RMLocation? {
        guard index < locations.count, index >= 0 else {
            return nil
        }
        return locations[index]
    }
    
    public func fetchLocations() {
        RMService.shared.execute(
            .listLocationsRequests,
            expecting: RMGetAllLocationsResponse.self
        ) {[weak self] result in
            switch result {
            case .success(let model):
                self?.apiInfo = model.info
                self?.locations = model.results
                
                DispatchQueue.main.async {
                    self?.delegate?.didFetchInitialLocations()
                }
                
            case .failure(_):
                break
            }
        }
    }
    
    /// Paginate if additional locations are needed
    public func fetchAdditionalLocations() {
        isLoadingMoreLocations = true
        guard let urlString = apiInfo?.next,
              let url = URL(string: urlString),
              let request = RMRequest(url: url) else {
            print("Failed to create request")
            isLoadingMoreLocations = false
            return
        }
        
        RMService.shared.execute(
            request,
            expecting: RMGetAllLocationsResponse.self,
            completion: { [weak self] result in
                switch result {
                case .success(let responseModel):
                    let moreResults = responseModel.results
                    self?.apiInfo = responseModel.info

                    self?.locations.append(contentsOf: responseModel.results)

                    DispatchQueue.main.async {
                        self?.isLoadingMoreLocations = false
                        // Notify via callback
                        self?.didLoadMoreLocationHandler?()
                    }

                    print("More locations: \(moreResults.count)")
                case .failure(let failure):
                    print(String(describing: failure))
                    self?.isLoadingMoreLocations = false
                }
            }
        )
    }
}
