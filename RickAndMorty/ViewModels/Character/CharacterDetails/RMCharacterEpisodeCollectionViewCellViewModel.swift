//
//  RMCharacterEpisodeCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 08/06/2024.
//

import UIKit

// MARK: - ViewModel Implementation
final class RMCharacterEpisodeCollectionViewCellViewModel: RMCharacterEpisodeCollectionViewCellViewModelProtocol {

    let borderColor: UIColor

    private let episodeDataUrl: URL?
    private var isFetching = false
    private var dataBlock: ((RMEpisodeDataRenderProtocol) -> Void)?
    private let service: RMServiceProtocol

    private var episode: RMEpisodeProtocol? {
        didSet {
            guard let model = episode else {
                return
            }
            dataBlock?(model)
        }
    }

    // MARK: - Init
    init(
        episodeDataUrl: URL?,
        borderColor: UIColor = .systemBlue,
        service: RMServiceProtocol = RMService.shared
    ) {
        self.episodeDataUrl = episodeDataUrl
        self.borderColor = borderColor
        self.service = service
    }

    // Register a data block to be called when episode data is available
    func registerForData(_ block: @escaping (RMEpisodeDataRenderProtocol) -> Void) {
        self.dataBlock = block
    }

    // MARK: - FetchData
    // Fetch the episode data
    func fetchEpisode() {
        guard !isFetching else {
            if let model = episode {
                dataBlock?(model)
            }

            return
        }

        guard let url = episodeDataUrl else {
            NSLog(RMServiceError.invalidURL.localizedDescription)

            return
        }

        guard let request = createRequest(from: url) else {
            NSLog(RMServiceError.failedToCreateRequest.localizedDescription)

            return
        }

        isFetching = true
        service.execute(
            request,
            expecting: RMEpisode.self
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.handleResult(result)
            }
        }
    }

    // Create a request from the given URL
    private func createRequest(from url: URL) -> RMRequest? {
        return RMRequest(url: url)
    }

    // Handle the result of the network request
    private func handleResult(_ result: Result<RMEpisode, Error>) {
        switch result {
        case .success(let model):
            episode = model
        case .failure(let error):
            NSLog("Failed to fetch character related episodes: \(error.localizedDescription)")
        }
        isFetching = false
    }
}

// MARK: - Hashable
extension RMCharacterEpisodeCollectionViewCellViewModel: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.episodeDataUrl?.absoluteString ?? "")
    }

    static func == (lhs: RMCharacterEpisodeCollectionViewCellViewModel, rhs: RMCharacterEpisodeCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
