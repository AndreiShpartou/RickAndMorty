//
//  RMCharacterCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 05/06/2024.
//

import Foundation

final class RMCharacterCollectionViewCellViewModel {

    let characterName: String

    var characterStatusText: String {
        return "Status: \(characterStatus.text)"
    }

    private(set) var characterImageUrl: URL?
    private let characterStatus: RMCharacterStatus

    // MARK: - Init
    init(
        characterName: String,
        characterStatus: RMCharacterStatus,
        characterImageUrl: URL?
    ) {
        self.characterName = characterName
        self.characterStatus = characterStatus
        self.characterImageUrl = characterImageUrl
    }

    func fetchImage(completion: @escaping (Result<Data, Error>, URL?) -> Void) {
        guard let url = characterImageUrl else {
            completion(.failure(URLError(.badURL)), nil)
            return
        }

        RMImageLoader.shared.downloadImage(url, completion: completion)
    }
}

// MARK: - Hashable
extension RMCharacterCollectionViewCellViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(characterName)
        hasher.combine(characterStatus)
        hasher.combine(characterImageUrl)
    }

    static func == (lhs: RMCharacterCollectionViewCellViewModel, rhs: RMCharacterCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
