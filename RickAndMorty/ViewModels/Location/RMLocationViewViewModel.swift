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
    weak var delegate: RMLocationViewViewModelDelegate?

    var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }

    private(set) var cellViewModels: [RMLocationTableViewCellViewModel] = []

    var isLoadingMoreLocations = false

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

    func registerDidLoadMoreLocation(with block: @escaping () -> Void) {
        didLoadMoreLocationHandler = block
    }

    func location(at index: Int) -> RMLocation? {
        guard index < locations.count, index >= 0 else {
            return nil
        }
        return locations[index]
    }

    func fetchLocations() {
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

            case .failure:
                break
            }
        }
    }

    /// Paginate if additional locations are needed
    func fetchAdditionalLocations() {
        isLoadingMoreLocations = true
        guard let urlString = apiInfo?.next,
              let url = URL(string: urlString),
              let request = RMRequest(url: url) else {
//            print("Failed to create request")
            isLoadingMoreLocations = false
            return
        }

        RMService.shared.execute(
            request,
            expecting: RMGetAllLocationsResponse.self,
            completion: { [weak self] result in
                switch result {
                case .success(let responseModel):
                    self?.apiInfo = responseModel.info

                    self?.locations.append(contentsOf: responseModel.results)

                    DispatchQueue.main.async {
                        // Notify via callback
                        self?.didLoadMoreLocationHandler?()
                        self?.isLoadingMoreLocations = false
                    }
                case .failure:
//                    print(String(describing: failure))
                    self?.isLoadingMoreLocations = false
                }
            }
        )
    }

    func fetchAdditionalLocationsWithDelay(_ delay: TimeInterval) {
        isLoadingMoreLocations = true
        Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak self] _ in
            self?.fetchAdditionalLocations()
        }
    }
}
