//
//  RMLocationViewViewModel.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 12/06/2024.
//

import Foundation

// MARK: - ViewModel Implementation
// View Model to handle location view logic
final class RMLocationViewViewModel: RMLocationViewViewModelProtocol {

    weak var delegate: RMLocationViewViewModelDelegate?

    var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }

    var nextUrlString: String? {
        return apiInfo?.next
    }

    private(set) var cellViewModels: [RMLocationTableViewCellViewModelWrapper] = []

    private(set) var isLoadingMoreLocations = false

    private var service: RMServiceProtocol

    private var locations: [RMLocationProtocol] = [] {
        didSet {
            for location in locations {
                let cellViewModel = RMLocationTableViewCellViewModelWrapper(
                    RMLocationTableViewCellViewModel(
                        name: location.name,
                        type: location.type,
                        dimension: location.dimension,
                        id: location.id
                    )
                )

                if !cellViewModels.contains(cellViewModel) {
                    cellViewModels.append(cellViewModel)
                }
            }
        }
    }
    // Location response info
    // Will contain next url, if present
    private var apiInfo: RMResponseInfo?

    // MARK: - Init
    init(service: RMServiceProtocol = RMService.shared) {
        self.service = service
    }

    // MARK: - Fetching locations
    func fetchLocations() {
        service.execute(
            .listLocationsRequests,
            expecting: RMGetAllLocationsResponse.self
        ) { [weak self] result in
            switch result {
            case .success(let responseModel):
                self?.handleInitialFetchSuccess(responseModel)
            case .failure(let error):
                NSLog("Failed to fetch initial locations: \(error.localizedDescription)")
            }
        }
    }

    // Paginate if additional locations are needed
    func fetchAdditionalLocations() {
        isLoadingMoreLocations = true
        guard let urlString = apiInfo?.next,
              let url = URL(string: urlString),
              let request = RMRequest(url: url) else {

            isLoadingMoreLocations = false

            return
        }

        service.execute(
            request,
            expecting: RMGetAllLocationsResponse.self,
            completion: { [weak self] result in
                switch result {
                case .success(let responseModel):
                    self?.handleAdditionalFetchSuccess(responseModel)
                case .failure(let error):
                    NSLog("Failed to fetch additional locations: \(error.localizedDescription)")
                    self?.isLoadingMoreLocations = false
                }
            }
        )
    }

    func getLocation(at index: Int) -> RMLocationProtocol {
        return locations[index]
    }

    // MARK: - Delay
    func fetchAdditionalLocationsWithDelay(_ delay: TimeInterval) {
        isLoadingMoreLocations = true
        Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak self] _ in
            self?.fetchAdditionalLocations()
        }
    }

    // MARK: - PrivateMethods
    private func handleInitialFetchSuccess(_ responseModel: RMGetAllLocationsResponse) {
        apiInfo = responseModel.info
        locations = responseModel.results

        DispatchQueue.main.async {
            self.delegate?.didLoadInitialLocations()
        }
    }

    private func handleAdditionalFetchSuccess(_ responseModel: RMGetAllLocationsResponse) {
        apiInfo = responseModel.info
        locations.append(contentsOf: responseModel.results)

        DispatchQueue.main.async {
            // Notify via callback
            self.delegate?.didLoadMoreLocations()
            self.isLoadingMoreLocations = false
        }
    }
}
