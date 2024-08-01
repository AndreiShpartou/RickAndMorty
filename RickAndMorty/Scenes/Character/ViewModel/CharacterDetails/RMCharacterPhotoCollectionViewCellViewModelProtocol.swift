//
//  RMCharacterPhotoCollectionViewCellViewModelProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 06/07/2024.
//

import Foundation

protocol RMCharacterPhotoCollectionViewCellViewModelProtocol: AnyObject {
    func fetchImage(completion: @escaping (Result<Data, Error>, URL?) -> Void)
}
