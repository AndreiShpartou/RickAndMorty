//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 06/06/2024.
//

import Foundation

final class RMCharacterDetailViewViewModel {
    
    enum SectionType: CaseIterable {
        case photo
        case information
        case episodes
    }
    
    public let sections = SectionType.allCases
    
    public var title: String {
        character.name.uppercased()
    }
    
    private let character: RMCharacter
    
    private var requestUrl: URL? {
        return URL(string: character.url)
    }
    
    // MARK: - Init
    init(character: RMCharacter) {
        self.character = character
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
