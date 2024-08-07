//
//  RMSearchResultViewViewModel.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 15/06/2024.
//

import Foundation

// MARK: - ViewModel Implementation
final class RMSearchResultsViewViewModel: RMSearchResultsViewViewModelProtocol {

    var shouldShowLoadMoreIndicator: Bool {
        return next != nil
    }

    private(set) var isLoadingMoreResults = false
    private(set) var results: RMSearchResultsType

    private var next: String?
    private var loadPageHandler: (([Codable]) -> Void)?
    private let service: RMServiceProtocol

    // MARK: - Init
    init(
        results: RMSearchResultsType,
        next: String? = nil,
        service: RMServiceProtocol = RMService.shared
    ) {
        self.results = results
        self.next = next
        self.service = service
    }

    // MARK: - HandlerRegister
    func registerLoadPageHandler(handler: @escaping (([Codable]) -> Void)) {
        self.loadPageHandler = handler
    }

    // MARK: - FetchResults
    func fetchAdditionalResults(completion: @escaping ([Any]) -> Void) {
        fetchResults(completion: completion, expecting: getResponseType())
    }

    // MARK: - Delay
    func fetchAdditionalResultsWithDelay(_ delay: TimeInterval, completion: @escaping ([Any]) -> Void) {
        isLoadingMoreResults = true
        Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak self] _ in
            self?.fetchAdditionalResults(completion: completion)
        }
    }

    // MARK: - Private
    private func getResponseType() -> any RMPagedResponseProtocol.Type {
        switch results {
        case .characters:
            return RMGetAllCharactersResponse.self
        case .episodes:
            return RMGetAllEpisodesResponse.self
        case .locations:
            return RMGetAllLocationsResponse.self
        }
    }

    private func fetchResults<T: RMPagedResponseProtocol>(
        completion: @escaping ([Any]) -> Void,
        expecting: T.Type
    ) {
        isLoadingMoreResults = true
        guard let urlString = next,
              let url = URL(string: urlString),
              let request = RMRequest(url: url) else {
            isLoadingMoreResults = false
            return
        }

        service.execute(request) { [weak self] (result: Result<T, Error>) in
            self?.processFetchedResults(result: result, completion: completion)
        }
    }

    private func processFetchedResults<T: Codable>(
        result: Result<T, Error>,
        completion: @escaping ([Any]) -> Void
    ) where T: RMPagedResponseProtocol {
        switch result {
        case .success(let responseModel):
            let moreResults = responseModel.results
            self.next = responseModel.info.next
            self.loadPageHandler?(moreResults)
            let additionalResults = convertResults(results: moreResults)
            updateResults(with: additionalResults)
            DispatchQueue.main.async {
                self.isLoadingMoreResults = false
                completion(additionalResults)
            }
        case .failure(let error):
            NSLog("Failed to fetch additional results: \(error.localizedDescription)")
            self.isLoadingMoreResults = false
        }
    }

    // MARK: - ConvertResults
    private func convertResults<T: Codable>(results: [T]) -> [Any] {
        if let characters = results as? [RMCharacter] {
            return characters.map {
                RMCharacterCollectionViewCellViewModelWrapper(
                    RMCharacterCollectionViewCellViewModel(
                        characterName: $0.name,
                        characterStatus: $0.status,
                        characterImageUrl: URL(string: $0.image)
                    )
                )
            }
        } else if let episodes = results as? [RMEpisode] {
            return episodes.map {
                RMEpisodeCollectionViewCellViewModelWrapper(
                    RMEpisodeCollectionViewCellViewModel(
                        name: $0.name,
                        air_date: $0.air_date,
                        episode: $0.episode,
                        borderColor: RMBorderColors.randomColor(),
                        episodeStringUrl: $0.url
                    )
                )
            }
        } else if let locations = results as? [RMLocation] {
            return locations.map {
                RMLocationTableViewCellViewModelWrapper(
                    RMLocationTableViewCellViewModel(
                        name: $0.name,
                        type: $0.type,
                        dimension: $0.dimension,
                        id: $0.id
                    )
                )
            }
        } else {
            return []
        }
    }

    // MARK: - UpdateResults
    private func updateResults<T>(with additionalResults: [T]) {
        switch self.results {
        case .characters(let existingResults):
            if let additionalResults = additionalResults as? [RMCharacterCollectionViewCellViewModelWrapper] {
                self.results = .characters(existingResults + additionalResults)
            }
        case .episodes(let existingResults):
            if let additionalResults = additionalResults as? [RMEpisodeCollectionViewCellViewModelWrapper] {
                self.results = .episodes(existingResults + additionalResults)
            }
        case .locations(let existingResults):
            if let additionalResults = additionalResults as? [RMLocationTableViewCellViewModelWrapper] {
                self.results = .locations(existingResults + additionalResults)
            }
        }
    }
}
