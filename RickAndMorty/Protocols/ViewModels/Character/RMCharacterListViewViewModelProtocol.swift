//
//  RMCharacterListViewViewModelProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 04/07/2024.
//

import Foundation

protocol RMCharacterListViewViewModelProtocol: AnyObject {
    var delegate: RMCharacterListViewViewModelDelegate? { get set }
    var shouldShowLoadMoreIndicator: Bool { get }
    var nextUrlString: String? { get }
    var cellViewModels: [RMCharacterCollectionViewCellViewModelWrapper] { get }
    var isLoadingMoreCharacters: Bool { get }

    func fetchCharacters()
    func fetchAdditionalCharacters()
    func fetchAdditionalCharactersWithDelay(_ delay: TimeInterval)
    func getCharacter(at index: Int) -> RMCharacterProtocol
}

protocol RMCharacterListViewViewModelDelegate: AnyObject {
    func didLoadInitialCharacters()
    func didLoadMoreCharacters(with newIndexPath: [IndexPath])
}
