//
//  RMEpisodeListViewViewModel.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 09/06/2024.
//

import UIKit

// MARK: - ViewModel Implementation
// View Model to handle episode list view logic
final class RMEpisodeListViewViewModel: RMEpisodeListViewViewModelProtocol {

    weak var delegate: RMEpisodeListViewViewModelDelegate?

    var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }

    var nextUrlString: String? {
        return apiInfo?.next
    }

    private(set) var isLoadingMoreEpisodes = false

    private(set) var cellViewModels: [RMEpisodeCollectionViewCellViewModelWrapper] = []

    private var service: RMServiceProtocol

    private var episodes: [RMEpisodeProtocol] = [] {
        didSet {
            for episode in episodes {
                let viewModel = RMEpisodeCollectionViewCellViewModelWrapper(
                    RMEpisodeCollectionViewCellViewModel(
                        name: episode.name,
                        air_date: episode.air_date,
                        episode: episode.episode,
                        borderColor: RMBorderColors.randomColor(),
                        episodeStringUrl: episode.url
                    )
                )

                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }

    private var apiInfo: RMResponseInfo?

    // MARK: - Init
    init(service: RMServiceProtocol = RMService.shared) {
        self.service = service
    }

    // MARK: - Fetching episodes
    // Fetch initial set of episodes(20)
    func fetchEpisodes() {
        RMService.shared.execute(
            .listEpisodesRequests,
            expecting: RMGetAllEpisodesResponse.self
        ) { [weak self] result in
            switch result {
            case .success(let responseModel):
                self?.handleInitialFetchSuccess(responseModel)
            case .failure(let error):
                NSLog("Failed to fetch initial set of episodes: \(error.localizedDescription)")
            }
        }
    }

    // Paginate if additional episodes are needed
    func fetchAdditionalEpisodes() {
        isLoadingMoreEpisodes = true
        guard let urlString = apiInfo?.next,
              let url = URL(string: urlString),
              let request = RMRequest(url: url) else {
            NSLog(RMServiceError.failedToCreateRequest.localizedDescription)
            isLoadingMoreEpisodes = false

            return
        }

        RMService.shared.execute(
            request,
            expecting: RMGetAllEpisodesResponse.self,
            completion: { [weak self] result in
                switch result {
                case .success(let responseModel):
                    self?.handleAdditionalFetchSuccess(responseModel)
                case .failure(let error):
                    NSLog("Failed to fetch additional episodes: \(error.localizedDescription)")
                    self?.isLoadingMoreEpisodes = false
                }
            }
        )
    }

    // MARK: - Delay
    func fetchAdditionalEpisodesWithDelay(_ delay: TimeInterval) {
        isLoadingMoreEpisodes = true
        Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak self] _ in
            self?.fetchAdditionalEpisodes()
        }
    }

    func getEpisode(at index: Int) -> RMEpisodeProtocol {
        return episodes[index]
    }

    // MARK: - PrivateMethods
    private func handleInitialFetchSuccess(_ responseModel: RMGetAllEpisodesResponse) {
        apiInfo = responseModel.info
        episodes = responseModel.results

        DispatchQueue.main.async {
            self.delegate?.didLoadInitialEpisodes()
        }
    }

    private func handleAdditionalFetchSuccess(_ responseModel: RMGetAllEpisodesResponse) {
        let moreResults = responseModel.results
        let originalCount = episodes.count
        let newCount = moreResults.count
        let total = originalCount + newCount
        let startingIndex = total - newCount
        let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex + newCount)).compactMap {
            IndexPath(row: $0, section: 0)
        }

        apiInfo = responseModel.info
        episodes.append(contentsOf: moreResults)

        DispatchQueue.main.async {
            self.delegate?.didLoadMoreEpisodes(with: indexPathsToAdd)
            self.isLoadingMoreEpisodes = false
        }
    }
}
