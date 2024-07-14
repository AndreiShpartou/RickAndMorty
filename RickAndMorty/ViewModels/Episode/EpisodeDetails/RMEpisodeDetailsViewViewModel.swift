//
//  RMEpisodeDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 09/06/2024.
//

import Foundation

// MARK: - ViewModel Implementation
final class RMEpisodeDetailsViewViewModel: RMEpisodeDetailsViewViewModelProtocol {

    weak var delegate: RMEpisodeDetailsViewViewModelDelegate?

    private(set) var sections: [RMSectionType] = []

    private let endpointURL: URL?
    private let episode: RMEpisodeProtocol?
    private let service: RMServiceProtocol

    private var dataTuple: (episode: RMEpisodeProtocol, characters: [RMCharacterProtocol])? {
        didSet {
            setupSections()
            delegate?.didFetchEpisodeDetails()
        }
    }

    // MARK: - Init
    init(endpointURL: URL?, service: RMServiceProtocol = RMService.shared) {
        self.endpointURL = endpointURL
        self.episode = nil
        self.service = service
    }

    init(episode: RMEpisodeProtocol, service: RMServiceProtocol = RMService.shared) {
        self.service = service
        self.endpointURL = nil
        self.episode = episode
    }

    // MARK: - Public
    func fetchEpisodeData() {
        guard let url = endpointURL,
              let request = RMRequest(url: url) else {
            if let episode = episode {
                fetchRelatedCharacters(for: episode)
            }

            return
        }

        service.execute(
            request,
            expecting: RMEpisode.self
        ) { [weak self] result in
            switch result {
            case .success(let model):
                self?.fetchRelatedCharacters(for: model)
            case .failure(let error):
                NSLog("Failed to fetch episode detail: \(error.localizedDescription)")
            }
        }
    }

    // Fetch character model
    func character(at index: Int) -> RMCharacterProtocol? {
        return dataTuple?.characters[index]
    }

    func getDataToShare() -> [Any] {
        return [getEpisodeDescription()]
    }

    // MARK: - Private
    private func fetchRelatedCharacters(for episode: RMEpisodeProtocol) {
        let characterUrls = episode.characters.compactMap {
            return URL(string: $0)
        }
        let requests = characterUrls.compactMap {
            return RMRequest(url: $0)
        }

        // Notified when all done
        let group = DispatchGroup()
        var characters: [RMCharacterProtocol] = []

        requests.forEach { request in
            group.enter()
            service.execute(
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
            self.dataTuple = (episode: episode, characters: characters)
        }
    }

    // MARK: - DescriptionToShare
    private func getEpisodeDescription() -> RMShareItem {
        guard let dataTuple = dataTuple else {
            let text = "No description"
            return RMShareItem(subject: text, details: text)
        }

        let episode = dataTuple.episode
        let createdString = RMDateFormatterUtils.getShortFormattedString(from: episode.created)

        let subject = "Episode: \(episode.name)"
        let details = """
            Episode Name: "\(episode.name)"
            Air Date: "\(episode.air_date)"
            Episode: "\(episode.episode)"
            Created: "\(createdString)"
        """

        return RMShareItem(subject: subject, details: details)
    }

    // MARK: - SetupSections
    private func setupSections() {
        guard let dataTuple = dataTuple else {
            return
        }

        let episode = dataTuple.episode
        let characters = dataTuple.characters
        let createdString = RMDateFormatterUtils.getShortFormattedString(from: episode.created)

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
}
