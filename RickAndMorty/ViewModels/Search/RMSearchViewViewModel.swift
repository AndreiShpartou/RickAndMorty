//
//  RMSearchViewViewModel.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 13/06/2024.
//

import Foundation

// Responsibilities
// - Show search results
// - Show no results view
// - Kick off API requests

final class RMSearchViewViewModel {
    let config: RMSearchViewController.Config
    
    private var optionMapUpdateBlock: (((RMSearchInputViewViewModel.DynamicOption, String)) -> Void)?
    private var searResultHandler: ((RMSearchResultViewModel) -> Void)?
    
    private var optionMap: [RMSearchInputViewViewModel.DynamicOption: String] = [:]
    private var searchText: String = ""
    
    // MARK: - Init
    init(config: RMSearchViewController.Config) {
        self.config = config
    }
    
    // MARK: - Public
    public func set(value: String, for option: RMSearchInputViewViewModel.DynamicOption) {
        optionMap[option] = value
        let tuple = (option, value)
        optionMapUpdateBlock?(tuple)
    }
    
    public func set(query text: String) {
        self.searchText = text
    }
    
    public func registerOptionChangeBlock(
        _ block: @escaping ((RMSearchInputViewViewModel.DynamicOption, String)) -> Void
    ) {
        self.optionMapUpdateBlock = block
    }
    
    public func registerSearchResultHandler(_ block: @escaping (RMSearchResultViewModel) -> Void) {
        self.searResultHandler = block
    }
    
    public func executeSearch() {
        // Build arguments
        var queryParams: [URLQueryItem] = [
            URLQueryItem(name: "name", value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        ]
        
        // Add options
        queryParams.append(contentsOf: optionMap.enumerated().map({ _, element in
            let key = element.key
            let value = element.value
            return URLQueryItem(name: key.queryArgument, value: value)
        }))
        
        // Create request
        let request = RMRequest(
            endpoint: config.type.endpoint,
            queryParameters: queryParams
        )
        
        switch config.type.endpoint {
        case .character:
            makeSearchAPICall(RMGetAllCharactersResponse.self, request: request)
        case .episode:
            makeSearchAPICall(RMGetAllEpisodesResponse.self, request: request)
        case .location:
            makeSearchAPICall(RMGetAllLocationsResponse.self, request: request)
        }
    }
    
    // MARK: - Private
    private func makeSearchAPICall<T: Codable>(_ type: T.Type, request: RMRequest) {
        RMService.shared.execute(
            request,
            expecting: type) { result in
                // Notify view of results, no results, or error
                switch result {
                case .success(let model):
                    // Episodes and characters: CollectionView; Location: TableView
                    self.processSearchResults(model: model)
                case .failure(let failure):
                    print(String(describing: failure))
                }
            }
        
    }
    
    private func processSearchResults(model: Codable) {
        var resultsVM: RMSearchResultViewModel?
        if let characterResults = model as? RMGetAllCharactersResponse {
            resultsVM = .characters(characterResults.results.map({
                return RMCharacterCollectionViewCellViewModel(
                    characterName: $0.name,
                    characterStatus: $0.status,
                    characterImageUrl: URL(string: $0.image)
                )
            }))
        } else if let episodesResults = model as? RMGetAllEpisodesResponse {
            resultsVM = .episodes(episodesResults.results.map({
                return RMCharacterEpisodeCollectionViewCellViewModel(
                    episodeDataUrl: URL(string: $0.url)
                )
            }))
        } else if let locationsResults = model as? RMGetAllLocationsResponse {
            resultsVM = .locations(locationsResults.results.map({
                return RMLocationTableViewCellViewModel(location: $0)
            }))
        }
        
        if let results = resultsVM {
            self.searResultHandler?(results)
        } else {
            // fallback error
        }
    }
    
}
