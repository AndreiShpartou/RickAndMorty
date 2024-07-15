//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 06/06/2024.
//
import UIKit

// MARK: - ViewModel Implementation
final class RMCharacterDetailsViewViewModel: RMCharacterDetailsViewViewModelProtocol {

    weak var delegate: RMCharacterDetailsViewViewModelDelegate?

    var title: String {
        character.name.uppercased()
    }

    private(set) var sections: [RMSectionType] = []
    private let character: RMCharacterProtocol
    private let service: RMServiceProtocol
    // related episodes
    private var episodes: [RMEpisodeProtocol]?

    // MARK: - Init
    init(
        character: RMCharacterProtocol,
        service: RMServiceProtocol = RMService.shared
    ) {
        self.character = character
        self.service = service
    }

    // MARK: - Public
    func fetchCharacterData() {
        fetchRelatedEpisodes(for: character)
    }

    // Fetch episode model
    func getEpisode(at index: Int) -> RMEpisodeProtocol? {
        return episodes?[index]
    }

    func getDataToShare() -> [Any] {
        return [getCharacterDescription()]
    }

    // MARK: - Private
    private func fetchRelatedEpisodes(for character: RMCharacterProtocol) {
        let episodeUrls = character.episode.compactMap {
            return URL(string: $0)
        }
        let requests = episodeUrls.compactMap {
            return RMRequest(url: $0)
        }

        // Notified when all done
        let group = DispatchGroup()
        var episodes: [RMEpisodeProtocol] = []

        requests.forEach { request in
            group.enter()
            service.execute(
                request,
                expecting: RMEpisode.self
            ) { result in
                defer {
                    group.leave()
                }

                switch result {
                case .success(let model):
                    episodes.append(model)
                case .failure(let error):
                    NSLog("Failed to fetch episode related characters: \(error.localizedDescription)")
                }
            }
        }

        group.notify(queue: .main) { [weak self] in
            self?.episodes = episodes
            self?.setupSections()
            self?.delegate?.didFetchCharacterDetails()
        }
    }

    // MARK: - DescriptionToShare
    private func getCharacterDescription() -> RMShareItem {
        let subject = "Character: \(character.name)"
        // Add character details
        let details = """
            Name: "\(character.name)"
            Status: "\(character.status.rawValue)"
            Species: "\(character.species)"
            Gender: "\(character.gender.rawValue)"
            Origin: "\(character.origin.name)"
            Location: "\(character.location.name)"
        """
        return RMShareItem(subject: subject, details: details)
    }

    // MARK: - SetupSections
    private func setupSections() {
        guard let episodes = episodes else {
            return
        }

        let photoViewModel = RMCharacterPhotoCollectionViewCellViewModel(imageURL: URL(string: character.image))

        let infoViewModels = [
            RMCharacterInfoCollectionViewCellViewModel(type: .status, value: character.status.rawValue),
            RMCharacterInfoCollectionViewCellViewModel(type: .gender, value: character.gender.rawValue),
            RMCharacterInfoCollectionViewCellViewModel(type: .type, value: character.type),
            RMCharacterInfoCollectionViewCellViewModel(type: .species, value: character.species),
            RMCharacterInfoCollectionViewCellViewModel(type: .origin, value: character.origin.name),
            RMCharacterInfoCollectionViewCellViewModel(type: .location, value: character.location.name),
            RMCharacterInfoCollectionViewCellViewModel(type: .created, value: character.created),
            RMCharacterInfoCollectionViewCellViewModel(type: .episodeCount, value: "\(character.episode.count)")
        ]

        let episodeViewModels = episodes.compactMap {
            return RMEpisodeCollectionViewCellViewModelWrapper(
                RMEpisodeCollectionViewCellViewModel(
                    name: $0.name,
                    air_date: $0.air_date,
                    episode: $0.episode,
                    borderColor: RMBorderColors.randomColor(),
                    episodeStringUrl: $0.url
                )
            )
        }

        sections = [
            .photo(viewModel: photoViewModel),
            .characterInfo(viewModels: infoViewModels),
            .episodes(viewModels: episodeViewModels)
        ]
    }
}
