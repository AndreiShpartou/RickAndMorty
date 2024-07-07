//
//  RMEpisodeDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 09/06/2024.
//

import Foundation

protocol RMEpisodeDetailViewViewModelDelegate: AnyObject {
    func didFetchEpisodeDetail()
}

final class RMEpisodeDetailViewViewModel {

    weak var delegate: RMEpisodeDetailViewViewModelDelegate?

    enum SectionType {
        case information(viewModels: [RMEpisodeInfoCollectionViewCellViewModel])
        case characters(viewModels: [RMCharacterCollectionViewCellViewModelWrapper])
    }

    private(set) var cellViewModels: [SectionType] = []

    private let endpointURL: URL?

    private var dataTuple: (episode: RMEpisode, characters: [RMCharacter])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchEpisodeDetail()
        }
    }

    // MARK: - Init
    init(endpointURL: URL?) {
        self.endpointURL = endpointURL
    }
}

// MARK: - Public
extension RMEpisodeDetailViewViewModel {
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
extension RMEpisodeDetailViewViewModel {
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

    private func createCellViewModels() {
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

        cellViewModels = [
            .information(viewModels: [
                .init(title: "Episode Name", value: episode.name),
                .init(title: "Air Date", value: episode.air_date),
                .init(title: "Episode", value: episode.episode),
                .init(title: "Created", value: createdString)
            ]),
            .characters(viewModels: characters.compactMap {
                RMCharacterCollectionViewCellViewModelWrapper(
                    RMCharacterCollectionViewCellViewModel(
                        characterName: $0.name,
                        characterStatus: $0.status,
                        characterImageUrl: URL(string: $0.image)
                    )
                )
            })
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
