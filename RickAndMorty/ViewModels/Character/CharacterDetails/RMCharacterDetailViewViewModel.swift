//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 06/06/2024.
//
import UIKit

// MARK: - ViewModel Implementation
final class RMCharacterDetailViewViewModel: RMCharacterDetailViewViewModelProtocol {

    weak var delegate: RMCharacterDetailViewViewModelDelegate?

    var title: String {
        character.name.uppercased()
    }

    var episodes: [String] {
        character.episode
    }

    private(set) var sections: [SectionType] = []

    private let character: RMCharacterProtocol

    private var requestUrl: URL? {
        return URL(string: character.url)
    }

    // MARK: - Init
    init(character: RMCharacterProtocol) {
        self.character = character
        setupSections()
    }

    func getDataToShare() -> [Any] {
        return [getCharacterDescription()]
    }

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
            return RMCharacterEpisodeCollectionViewCellViewModelWrapper(
                RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0))
            )
        }

        sections = [
            .photo(viewModel: photoViewModel),
            .characterInfo(viewModels: infoViewModels),
            .episodes(viewModels: episodeViewModels)
        ]
    }
}

// MARK: - Layout
extension RMCharacterDetailViewViewModel {
    func createPhotoSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 10,
            trailing: 0
        )

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(1.0) // .fractionalHeight(0.5)
            ),
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)

        return section
    }

    func createInfoSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(UIDevice.isPhone ? 0.5 : 0.25),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 2,
            leading: 2,
            bottom: 2,
            trailing: 2
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(150)
            ),
            subitems: UIDevice.isPhone ? [item, item] : [item, item, item, item]
        )

        let section = NSCollectionLayoutSection(group: group)

        return section
    }

    func createEpisodeSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 5,
            bottom: 10,
            trailing: 5
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(UIDevice.isPhone ? 0.8 : 0.4),
                heightDimension: .absolute(150)
            ),
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging

        return section
    }
}
