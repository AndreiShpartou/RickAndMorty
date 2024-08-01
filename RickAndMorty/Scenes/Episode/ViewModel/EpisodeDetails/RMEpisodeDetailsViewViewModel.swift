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
    private let episode: RMEpisodeProtocol
    private let service: RMServiceProtocol

    private var characters: [RMCharacterProtocol]?

    // MARK: - Init
    init(
        episode: RMEpisodeProtocol,
        service: RMServiceProtocol = RMService.shared
    ) {
        self.episode = episode
        self.service = service
    }

    // MARK: - Public
    func fetchEpisodeData() {
        fetchRelatedCharacters(for: episode)
    }

    // Fetch character model
    func getCharacter(at index: Int) -> RMCharacterProtocol? {
        return characters?[index]
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

        group.notify(queue: .main) { [weak self] in
            self?.characters = characters
            self?.setupSections()
            self?.delegate?.didFetchEpisodeDetails()
        }
    }

    // MARK: - DescriptionToShare
    private func getEpisodeDescription() -> RMShareItem {

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
        guard let characters = characters else {
            return
        }

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
