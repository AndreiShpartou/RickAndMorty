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
    func fetchAdditionalResults(completion: @escaping ([any Hashable]) -> Void) {
        switch results {
        case .characters:
            fetchResults(completion: completion, handler: processFetchedCharacters)
        case .episodes:
            fetchResults(completion: completion, handler: processFetchedEpisodes)
        case .locations:
            fetchResults(completion: completion, handler: processFetchedLocations)
        }
    }

    // MARK: - Delay
    func fetchAdditionalResultsWithDelay(_ delay: TimeInterval, completion: @escaping ([any Hashable]) -> Void) {
        isLoadingMoreResults = true
        Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak self] _ in
            self?.fetchAdditionalResults(completion: completion)
        }
    }

    // MARK: - Private
    private func fetchResults<T: Codable, U>(
        completion: @escaping ([U]) -> Void,
        handler: @escaping (Result<T, Error>, @escaping ([U]) -> Void) -> Void
    ) {
        isLoadingMoreResults = true
        guard let urlString = next,
              let url = URL(string: urlString),
              let request = RMRequest(url: url) else {
            isLoadingMoreResults = false
            return
        }

        service.execute(request, expecting: T.self) { result in
            handler(result, completion)
        }
    }

    private func processFetchedCharacters(
        result: Result<RMGetAllCharactersResponse, Error>,
        completion: @escaping ([RMCharacterCollectionViewCellViewModelWrapper]) -> Void
    ) {
        switch result {
        case .success(let responseModel):
            let moreResults = responseModel.results
            self.next = responseModel.info.next
            self.loadPageHandler?(moreResults)
            let additionalResults = moreResults.map {
                RMCharacterCollectionViewCellViewModelWrapper(
                    RMCharacterCollectionViewCellViewModel(
                        characterName: $0.name,
                        characterStatus: $0.status,
                        characterImageUrl: URL(string: $0.image)
                    )
                )
            }
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

    private func processFetchedLocations(
        result: Result<RMGetAllLocationsResponse, Error>,
        completion: @escaping ([RMLocationTableViewCellViewModelWrapper]) -> Void
    ) {
        switch result {
        case .success(let responseModel):
            let moreResults = responseModel.results
            self.next = responseModel.info.next
            self.loadPageHandler?(moreResults)
            let additionalResults = moreResults.map {
                RMLocationTableViewCellViewModelWrapper(
                    RMLocationTableViewCellViewModel(location: $0)
                )
            }
            updateResults(with: additionalResults)
            DispatchQueue.main.async {
                completion(additionalResults)
                self.isLoadingMoreResults = false
            }
        case .failure(let error):
            NSLog("Failed to fetch additional locations search results: \(error.localizedDescription)")
            self.isLoadingMoreResults = false
        }
    }

    private func processFetchedEpisodes(
        result: Result<RMGetAllEpisodesResponse, Error>,
        completion: @escaping ([RMEpisodeCollectionViewCellViewModelWrapper]) -> Void
    ) {
        switch result {
        case .success(let responseModel):
            let moreResults = responseModel.results
            self.next = responseModel.info.next
            self.loadPageHandler?(moreResults)
            let additionalResults = moreResults.map {
                RMEpisodeCollectionViewCellViewModelWrapper(
                    RMEpisodeCollectionViewCellViewModel(
                        episodeDataUrl: URL(string: $0.url)
                    )
                )
            }
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
