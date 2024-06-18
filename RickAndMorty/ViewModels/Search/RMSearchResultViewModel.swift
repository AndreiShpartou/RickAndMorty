//
//  RMSearchResultViewModel.swift
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

final class RMSearchResultViewModel {
    
    public var shouldShowLoadMoreIndicator: Bool {
        return next != nil
    }
    
    public private(set) var isLoadingMoreResults = false
    
    public private(set) var results: RMSearchResultType
    
    private var next: String?
    
    // MARK: - Init
    init(results: RMSearchResultType, next: String? = nil) {
        self.results = results
        self.next = next
    }
    
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

                        print("More characters: \(moreResults.count)")
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

                        print("More episodes: \(moreResults.count)")
                    case .failure(let failure):
                        print(String(describing: failure))
                        self?.isLoadingMoreResults = false
                    }
                }
            )
        case .locations(let array):
            break
        case nil:
            break
        }
    }
    
    
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
                        self?.isLoadingMoreResults = false
                        // Notify via callback
                        completion(newResults)
                    }

                    print("More locations: \(moreResults.count)")
                case .failure(let failure):
                    print(String(describing: failure))
                    self?.isLoadingMoreResults = false
                }
            }
        )
    }
}

