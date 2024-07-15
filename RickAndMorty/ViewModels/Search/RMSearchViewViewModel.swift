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

final class RMSearchViewViewModel: RMSearchViewViewModelProtocol {

    private let service: RMServiceProtocol
    private(set) var configType: RMConfigType

    // Handler properties
    private var optionMapUpdateBlock: (((RMDynamicOption, String)) -> Void)?
    private var searchResultHandler: ((RMSearchResultsViewViewModelProtocol) -> Void)?
    private var noResultsHandler: (() -> Void)?
    private var processSearchHandler: (() -> Void)?
    // Search options
    private var optionMap: [RMDynamicOption: String] = [:]
    private var searchText: String = ""
    // Results
    private var searchResultModels: [Codable] = []

    // MARK: - Init
    init(
        configType: RMConfigType,
        service: RMServiceProtocol = RMService.shared
    ) {
        self.configType = configType
        self.service = service
    }

    // MARK: - Public
    func set(value: String, for option: RMDynamicOption) {
        optionMap[option] = value
        optionMapUpdateBlock?((option, value))
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

    func registerSearchResultHandler(_ block: @escaping (RMSearchResultsViewViewModelProtocol) -> Void) {
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

        makeSearchAPICall(getResponseType(), request: request)
    }
    // MARK: - Seeking for models
    func locationSearchResult(at index: Int) -> RMLocationProtocol? {
        guard let searchModels = searchResultModels as? [RMLocationProtocol] else {
            return nil
        }

        return searchModels[index]
    }

    func characterSearchResult(at index: Int) -> RMCharacterProtocol? {
        guard let searchModels = searchResultModels as? [RMCharacterProtocol] else {
            return nil
        }

        return searchModels[index]
    }

    func episodeSearchResult(at index: Int) -> RMEpisodeProtocol? {
        guard let searchModels = searchResultModels as? [RMEpisodeProtocol] else {
            return nil
        }

        return searchModels[index]
    }

    // MARK: - Private
    private func getResponseType() -> any RMPagedResponseProtocol.Type {
        switch configType.endpoint {
        case .character:
            return RMGetAllCharactersResponse.self
        case .location:
            return RMGetAllLocationsResponse.self
        case .episode:
            return RMGetAllEpisodesResponse.self
        }
    }

    private func makeSearchAPICall<T: Codable>(_ type: T.Type, request: RMRequest) {
        processSearchHandler?()
        service.execute(
            request,
            expecting: type
        ) { [weak self] result in
                // Notify view of results, no results, or error
                switch result {
                case .success(let model):
                    // Episodes and characters: CollectionView; Location: TableView
                    self?.processSearchResults(model: model)
                case .failure(let error):
                    NSLog("Failed to make search API call: \(error.localizedDescription)")
                    self?.handleNoResults()
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
                        name: $0.name,
                        air_date: $0.air_date,
                        episode: $0.episode,
                        borderColor: RMBorderColors.randomColor(),
                        episodeStringUrl: $0.url
                    )
                )
            })
            nextUrl = episodesResults.info.next
            self.searchResultModels = episodesResults.results
        } else if let locationsResults = model as? RMGetAllLocationsResponse {
            resultsVM = .locations(locationsResults.results.map {
                RMLocationTableViewCellViewModelWrapper(
                    RMLocationTableViewCellViewModel(
                        name: $0.name,
                        type: $0.type,
                        dimension: $0.dimension,
                        id: $0.id
                    )
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
