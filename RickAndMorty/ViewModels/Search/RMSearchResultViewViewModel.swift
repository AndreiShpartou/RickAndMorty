//
//  RMSearchResultViewViewModel.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 15/06/2024.
//

import Foundation

enum RMSearchResultType {
    case characters([RMCharacterCollectionViewCellViewModel])
    case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
    case locations([RMLocationTableViewCellViewModel])
}

final class RMSearchResultViewViewModel {
    
    public var shouldShowLoadMoreIndicator: Bool {
        return next != nil
    }
    
    public private(set) var isLoadingMoreResults = false
    
    public private(set) var results: RMSearchResultType
    
    private var next: String?
    
    private var loadPageHandler: (([Codable]) -> Void)?
    
    // MARK: - Init
    init(results: RMSearchResultType, next: String? = nil) {
        self.results = results
        self.next = next
    }
    
    public func registerLoadPageHandler(handler: @escaping (([Codable]) -> Void)) {
        self.loadPageHandler = handler
    }
    
    // MARK: - Fetch Results
    public func fetchAdditionalResults(completion: @escaping ([any Hashable]) -> Void) {
        isLoadingMoreResults = true
        guard let urlString = next,
              let url = URL(string: urlString),
              let request = RMRequest(url: url) else {
            print("Failed to create request")
            isLoadingMoreResults = false
            return
        }

        switch results {
        case .characters(let existingResults):
            RMService.shared.execute(
                request,
                expecting: RMGetAllCharactersResponse.self,
                completion: { [weak self] result in
                    switch result {
                    case .success(let responseModel):
                        let moreResults = responseModel.results
                        self?.next = responseModel.info.next
                        self?.loadPageHandler?(moreResults)

                        let additionalResults = moreResults.compactMap {
                            return RMCharacterCollectionViewCellViewModel(
                                characterName: $0.name,
                                characterStatus: $0.status,
                                characterImageUrl: URL(string: $0.image)
                            )
                        }

                        var newResults: [RMCharacterCollectionViewCellViewModel] = []
                        newResults = existingResults + additionalResults
                        self?.results = .characters(newResults)

                        DispatchQueue.main.async {
                            self?.isLoadingMoreResults = false
                            // Notify via callback
                            completion(newResults)
                        }
                    case .failure(let failure):
                        print(String(describing: failure))
                        self?.isLoadingMoreResults = false
                    }
                }
            )
        case .episodes(let existingResults):
            RMService.shared.execute(
                request,
                expecting: RMGetAllEpisodesResponse.self,
                completion: { [weak self] result in
                    switch result {
                    case .success(let responseModel):
                        let moreResults = responseModel.results
                        self?.next = responseModel.info.next
                        self?.loadPageHandler?(moreResults)

                        let additionalResults = moreResults.compactMap {
                            return RMCharacterEpisodeCollectionViewCellViewModel(
                                episodeDataUrl: URL(string: $0.url)
                            )
                        }

                        var newResults: [RMCharacterEpisodeCollectionViewCellViewModel] = []
                        newResults = existingResults + additionalResults
                        self?.results = .episodes(newResults)

                        DispatchQueue.main.async {
                            self?.isLoadingMoreResults = false
                            // Notify via callback
                            completion(newResults)
                        }
                    case .failure(let failure):
                        print(String(describing: failure))
                        self?.isLoadingMoreResults = false
                    }
                }
            )
        case .locations:
            break
        }
    }
    
    // MARK: - Fetch Locations
    public func fetchAdditionalLocations(completion: @escaping ([RMLocationTableViewCellViewModel]) -> Void) {
        isLoadingMoreResults = true
        guard let urlString = next,
              let url = URL(string: urlString),
              let request = RMRequest(url: url) else {
            print("Failed to create request")
            isLoadingMoreResults = false
            return
        }
        
        RMService.shared.execute(
            request,
            expecting: RMGetAllLocationsResponse.self,
            completion: { [weak self] result in
                switch result {
                case .success(let responseModel):
                    let moreResults = responseModel.results
                    self?.next = responseModel.info.next
                    self?.loadPageHandler?(moreResults)

                    let additionalLocations = moreResults.compactMap {
                        return RMLocationTableViewCellViewModel(location: $0)
                    }
                    
                    var newResults: [RMLocationTableViewCellViewModel] = []
                    switch self?.results {
                    case .locations(let existingLocations):
                        newResults = existingLocations + additionalLocations
                        self?.results = .locations(newResults)
                    case .episodes, .characters:
                        break
                    case .none:
                        break
                    }
                    
                    DispatchQueue.main.async {
                        // Notify via callback
                        completion(newResults)
                        self?.isLoadingMoreResults = false
                    }
                case .failure(let failure):
                    print(String(describing: failure))
                    self?.isLoadingMoreResults = false
                }
            }
        )
    }
    
    public func fetchAdditionalResultsWithDelay(_ delay: TimeInterval, completion: @escaping ([any Hashable]) -> Void) {
        isLoadingMoreResults = true
        Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak self] _ in
            self?.fetchAdditionalResults(completion: completion)
        }
    }
    
    public func fetchAdditionalLocationsWithDelay(_ delay: TimeInterval,
                                                  completion: @escaping ([RMLocationTableViewCellViewModel]) -> Void) {
        isLoadingMoreResults = true
        Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak self] _ in
            self?.fetchAdditionalLocations(completion: completion)
        }
    }
}

