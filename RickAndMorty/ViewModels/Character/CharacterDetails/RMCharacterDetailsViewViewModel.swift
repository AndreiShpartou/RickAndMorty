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

    var episodes: [String] {
        character.episode
    }

    private(set) var sections: [RMSectionType] = []

    private let character: RMCharacterProtocol

    private var requestUrl: URL? {
        return URL(string: character.url)
    }

    // MARK: - Init
    init(character: RMCharacterProtocol) {
        self.character = character
        setupSections()
        delegate?.didFetchCharacterDetails()
    }

    func getDataToShare() -> [Any] {
        return [getCharacterDescription()]
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

        let episodeViewModels = character.episode.compactMap {
            return RMEpisodeCollectionViewCellViewModelWrapper(
                RMEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0))
            )
        }

        sections = [
            .photo(viewModel: photoViewModel),
            .characterInfo(viewModels: infoViewModels),
            .episodes(viewModels: episodeViewModels)
        ]
    }
}
