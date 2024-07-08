//
//  RMEpisodeDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 09/06/2024.
//

import Foundation

final class RMEpisodeDetailsViewViewModel {

    weak var delegate: RMEpisodeDetailsViewViewModelDelegate?

    private(set) var sections: [SectionType] = []

    private let endpointURL: URL?
    private let service: RMServiceProtocol

    private var dataTuple: (episode: RMEpisode, characters: [RMCharacter])? {
        didSet {
            setupSections()
            delegate?.didFetchEpisodeDetail()
        }
    }

    // MARK: - Init
    init(endpointURL: URL?) {
        self.endpointURL = endpointURL
    }
}

// MARK: - Public
extension RMEpisodeDetailsViewViewModel {
    // Fetch episode model
    func fetchEpisodeData() {
        guard let url = endpointURL,
              let request = RMRequest(url: url) else {
            return
        }

        RMService.shared.execute(
            request,
            expecting: RMEpisode.self
        ) { [weak self] result in
                switch result {
                case .success(let model):
                    self?.fetchRelatedCharacters(episode: model)
                case .failure(let error):
                    NSLog("Failed to fetch episode detail: \(error.localizedDescription)")
                }
        }
    }

    func character(at index: Int) -> RMCharacter? {
        guard let dataTuple = dataTuple else {
            return nil
        }

        return dataTuple.characters[index]
    }

    func getDataToShare() -> [Any] {
        return [getEpisodeDescription()]
    }
}

// MARK: - Private
extension RMEpisodeDetailsViewViewModel {
    private func fetchRelatedCharacters(episode: RMEpisode) {
        let characterUrls = episode.characters.compactMap {
            return URL(string: $0)
        }

        let requests = characterUrls.compactMap {
            return RMRequest(url: $0)
        }

        // n numbers of parallel requests
        // Notified when all done
        let group = DispatchGroup()
        var characters: [RMCharacter] = []

        requests.forEach { request in
            group.enter()
            RMService.shared.execute(
                request,
                expecting: RMCharacter.self
            ) { result in
                    defer {
                        group.leave()
                    }

                    switch result {
                    case .success(let model):
                        characters.append(model)
                    case .failure(let error):
                        NSLog("Failed to fetch episode related characters: \(error.localizedDescription)")
                    }
            }
        }

        group.notify(queue: .main) {
            self.dataTuple = (
                episode: episode,
                characters: characters
            )
        }
    }

    private func setupSections() {
        guard let dataTuple = dataTuple else {
            return
        }

        let episode = dataTuple.episode
        let characters = dataTuple.characters
        var createdString = episode.created
        if let date = RMDateFormatterUtils.formatter.date(
            from: episode.created
        ) {
            createdString = RMDateFormatterUtils.shortFormatter.string(
                from: date
            )
        }

        let infoViewModels = [
            RMEpisodeInfoCollectionViewCellViewModel(title: "Episode Name", value: episode.name),
            RMEpisodeInfoCollectionViewCellViewModel(title: "Air Date", value: episode.air_date),
            RMEpisodeInfoCollectionViewCellViewModel(title: "Episode", value: episode.episode),
            RMEpisodeInfoCollectionViewCellViewModel(title: "Created", value: createdString)
        ]

        let characterViewModels = characters.compactMap {
            RMCharacterCollectionViewCellViewModelWrapper(
                RMCharacterCollectionViewCellViewModel(
                    characterName: $0.name,
                    characterStatus: $0.status,
                    characterImageUrl: URL(string: $0.image)
                )
            )
        }

        sections = [
            .episodeInfo(viewModels: infoViewModels),
            .characters(viewModels: characterViewModels)
        ]
    }

    private func getEpisodeDescription() -> RMShareItem {
        guard let dataTuple = dataTuple else {
            let text = "No description"
            return RMShareItem(subject: text, details: text)
        }

        let episode = dataTuple.episode
        var createdString = episode.created
        if let date = RMDateFormatterUtils.formatter.date(
            from: episode.created
        ) {
            createdString = RMDateFormatterUtils.shortFormatter.string(
                from: date
            )
        }

        let subject = "Episode: \(episode.name)"
        let details = """
            Episode Name: "\(episode.name)"
            Air Date: "\(episode.air_date)"
            Episode: "\(episode.episode)"
            Created: "\(createdString)"
        """

        return RMShareItem(subject: subject, details: details)
    }
}
