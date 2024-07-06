//
//  RMCharacterCollectionViewCellViewModelProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 06/07/2024.
//

import Foundation

protocol RMCharacterCollectionViewCellViewModelProtocol: AnyObject {
    var characterName: String { get }
    var characterStatusText: String { get }
    var characterImageUrl: URL? { get }

    func fetchImage(completion: @escaping (Result<Data, Error>, URL?) -> Void)
}
