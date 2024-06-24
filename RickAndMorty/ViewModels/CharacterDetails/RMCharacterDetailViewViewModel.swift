//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 06/06/2024.
//
import UIKit

final class RMCharacterDetailViewViewModel {
    
    enum SectionType {
        case photo(viewModel: RMCharacterPhotoCollectionViewCellViewModel)
        case information(viewModels: [RMCharacterInfoCollectionViewCellViewModel])
        case episodes(viewModels: [RMCharacterEpisodeCollectionViewCellViewModel])
    }
    
    public var sections: [SectionType] = []
    
    public var title: String {
        character.name.uppercased()
    }
    
    public var episodes: [String] {
        character.episode
    }
    
    private let character: RMCharacter
    
    private var requestUrl: URL? {
        return URL(string: character.url)
    }
    
    // MARK: - Init
    init(character: RMCharacter) {
        self.character = character
        setupSections()
    }
    
    // MARK: - SetupSections
    private func setupSections() {
        /*
         let id: Int
         let name: String
         let status: RMCharacterStatus
         let species: String
         let type: String
         let gender: RMCharacterGender
         let origin: RMOriginLocation
         let location: RMLastLocation
         let image: String
         let episode: [String]
         let url: String
         let created: String
         */
        sections = [
            .photo(viewModel: .init(imageURL: URL(string: character.image))),
            .information(viewModels: [
                .init(type: .status, value: character.status.rawValue),
                .init(type: .gender, value: character.gender.rawValue),
                .init(type: .type, value: character.type),
                .init(type: .species, value: character.species),
                .init(type: .origin, value: character.origin.name),
                .init(type: .location, value: character.location.name),
                .init(type: .created ,value: character.created),
                .init(type: .episodeCount ,value: "\(character.episode.count)")
            ]),
            .episodes(viewModels: character.episode.compactMap {
                return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0))
            })
        ]
    }

}

// MARK: - Layout
extension RMCharacterDetailViewViewModel {
    public func createPhotoSectionLayout() -> NSCollectionLayoutSection {
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
                heightDimension: .fractionalWidth(1.0) //.fractionalHeight(0.5)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    public func createInfoSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(UIDevice.isiPhone ? 0.5 : 0.25),
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
            subitems: UIDevice.isiPhone ? [item, item] : [item, item, item, item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    public func createEpisodeSectionLayout() -> NSCollectionLayoutSection {
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
                widthDimension: .fractionalWidth(UIDevice.isiPhone ? 0.8 : 0.4),
                heightDimension: .absolute(150)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
}






//    public func fetchCharacterData() {
//        print(character.url)
//        guard let url = requestUrl,
//              let request = RMRequest(url: url) else {
//            return
//        }
//
//        RMService.shared.execute(request,
//                                 expecting: RMCharacter.self) { result in
//            switch result {
//            case .success(let success):
//                print(String(describing: success))
//            case .failure(let failure):
//                print(String(describing: failure))
//            }
//
//        }
//
//    }
