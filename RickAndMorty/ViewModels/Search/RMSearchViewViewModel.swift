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

    let configType: RMConfigType

    private var optionMapUpdateBlock: (((RMDynamicOption, String)) -> Void)?
    private var searchResultHandler: ((RMSearchResultsViewViewModel) -> Void)?
    private var noResultsHandler: (() -> Void)?
    private var processSearchHandler: (() -> Void)?

    private var optionMap: [RMDynamicOption: String] = [:]
    private var searchText: String = ""
    private var searchResultModels: [Codable] = []

    // MARK: - Init
    init(configType: RMConfigType) {
        self.configType = configType
    }

    // MARK: - Public
    func set(value: String, for option: RMDynamicOption) {
        optionMap[option] = value
        let tuple = (option, value)
        optionMapUpdateBlock?(tuple)
    }

    func set(query text: String) {
        self.searchText = text
    }

    // MARK: - HandlerRegister
    func registerOptionChangeBlock(
        _ block: @escaping ((RMDynamicOption, String)) -> Void
    ) {
        self.optionMapUpdateBlock = block
    }

    func registerSearchResultHandler(_ block: @escaping (RMSearchResultsViewViewModel) -> Void) {
        self.searchResultHandler = block
    }

    func registerNoResultsHandler(_ block: @escaping () -> Void) {
        self.noResultsHandler = block
    }

    func registerProcessSearchHandler(_ block: @escaping () -> Void) {
        self.processSearchHandler = block
    }

    // MARK: - Search
    func executeSearch() {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }

        // Build arguments
        var queryParams: [URLQueryItem] = [
            URLQueryItem(name: "name", value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        ]

        // Add options
        queryParams.append(contentsOf: optionMap.enumerated().map { _, element in
            let key = element.key
            let value = element.value
            return URLQueryItem(name: key.queryArgument, value: value)
        })

        // Create request
        let request = RMRequest(
            endpoint: configType.endpoint,
            queryParameters: queryParams
        )

        switch configType.endpoint {
        case .character:
            makeSearchAPICall(RMGetAllCharactersResponse.self, request: request)
        case .episode:
            makeSearchAPICall(RMGetAllEpisodesResponse.self, request: request)
        case .location:
            makeSearchAPICall(RMGetAllLocationsResponse.self, request: request)
        }
    }
    // MARK: - Seeking for models
    func locationSearchResult(at index: Int) -> RMLocation? {
        guard let searchModels = searchResultModels as? [RMLocation] else {
            return nil
        }

        return searchModels[index]
    }

    func characterSearchResult(at index: Int) -> RMCharacter? {
        guard let searchModels = searchResultModels as? [RMCharacter] else {
            return nil
        }

        return searchModels[index]
    }

    func episodeSearchResult(at index: Int) -> RMEpisode? {
        guard let searchModels = searchResultModels as? [RMEpisode] else {
            return nil
        }

        return searchModels[index]
    }

    // MARK: - Private
    private func makeSearchAPICall<T: Codable>(_ type: T.Type, request: RMRequest) {
        processSearchHandler?()
        RMService.shared.execute(
            request,
            expecting: type
        ) { result in
                // Notify view of results, no results, or error
                switch result {
                case .success(let model):
                    // Episodes and characters: CollectionView; Location: TableView
                    self.processSearchResults(model: model)
                case .failure(let error):
                    NSLog("Failed to make search API call: \(error.localizedDescription)")
                    self.handleNoResults()
                }
        }
    }

    private func processSearchResults(model: Codable) {
        var resultsVM: RMSearchResultsType?
        var nextUrl: String?
        if let characterResults = model as? RMGetAllCharactersResponse {
            resultsVM = .characters(characterResults.results.map {
                return RMCharacterCollectionViewCellViewModelWrapper(
                    RMCharacterCollectionViewCellViewModel(
                        characterName: $0.name,
                        characterStatus: $0.status,
                        characterImageUrl: URL(string: $0.image)
                    )
                )
            })
            nextUrl = characterResults.info.next
            self.searchResultModels = characterResults.results
        } else if let episodesResults = model as? RMGetAllEpisodesResponse {
            resultsVM = .episodes(episodesResults.results.map {
                return RMEpisodeCollectionViewCellViewModelWrapper(
                    RMEpisodeCollectionViewCellViewModel(
                        episodeDataUrl: URL(string: $0.url)
                    )
                )
            })
            nextUrl = episodesResults.info.next
            self.searchResultModels = episodesResults.results
        } else if let locationsResults = model as? RMGetAllLocationsResponse {
            resultsVM = .locations(locationsResults.results.map {
                RMLocationTableViewCellViewModelWrapper(
                    RMLocationTableViewCellViewModel(location: $0)
                )
            })
            nextUrl = locationsResults.info.next
            self.searchResultModels = locationsResults.results
        }

        if let results = resultsVM {
            let viewModel = RMSearchResultsViewViewModel(results: results, next: nextUrl)
            self.searchResultHandler?(viewModel)
            viewModel.registerLoadPageHandler { [weak self] moreResults in

                self?.searchResultModels.append(contentsOf: moreResults)
            }
        } else {
            handleNoResults()
        }
    }

    private func handleNoResults() {
        noResultsHandler?()
    }
}
