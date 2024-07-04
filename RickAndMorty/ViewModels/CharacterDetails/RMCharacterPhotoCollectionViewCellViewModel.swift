//
//  RMCharacterPhotoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 08/06/2024.
//

import Foundation

final class RMCharacterPhotoCollectionViewCellViewModel {

    private let imageURL: URL?

    init(imageURL: URL?) {
        self.imageURL = imageURL
    }

    func fetchImage(completion: @escaping (Result<Data, Error>, URL?) -> Void) {
        guard let imageURL = imageURL else {
            completion(.failure(URLError(.badURL)), nil)
            return
        }

        RMImageLoader.shared.downloadImage(imageURL, completion: completion)
    }
}
