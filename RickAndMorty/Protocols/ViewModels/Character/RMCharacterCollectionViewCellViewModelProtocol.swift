//
//  RMCharacterCollectionViewCellViewModelProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 06/07/2024.
//

import Foundation

protocol RMCharacterCollectionViewCellViewModelProtocol: AnyObject, Hashable {
    var characterName: String { get }
    var characterStatusText: String { get }
    var characterImageUrl: URL? { get }

    func fetchImage(completion: @escaping (Result<Data, Error>, URL?) -> Void)
}

// To use this protocol without needing any keyword and suffering performance issues, create a type-erased wrapper.
// This wrapper hides the concrete type of the wrapped instance while preserving its `Hashable` conformance
final class RMCharacterCollectionViewCellViewModelWrapper: RMCharacterCollectionViewCellViewModelProtocol {

    var characterName: String {
        return _characterName()
    }

    var characterStatusText: String {
        return _characterStatusText()
    }

    var characterImageUrl: URL? {
        return _characterImageUrl()
    }

    // AnyHashable to store the base object for hashable conformance
    private let _base: AnyHashable
    // Closures to pass the protocol requirements to the wrapped instance
    private let _characterName: () -> String
    private let _characterStatusText: () -> String
    private let _characterImageUrl: () -> URL?
    private let _fetchImage: (@escaping (Result<Data, Error>, URL?) -> Void) -> Void

    init<T: RMCharacterCollectionViewCellViewModelProtocol>(_ base: T) {
        _base = AnyHashable(base)
        _characterName = {
            base.characterName
        }
        _characterStatusText = {
            base.characterStatusText
        }
        _characterImageUrl = {
            base.characterImageUrl
        }
        _fetchImage = base.fetchImage
    }

    func fetchImage(completion: @escaping (Result<Data, Error>, URL?) -> Void) {
        _fetchImage(completion)
    }

    // Conformance to Hashable requirements
    func hash(into hasher: inout Hasher) {
        _base.hash(into: &hasher)
    }

    static func == (lhs: RMCharacterCollectionViewCellViewModelWrapper, rhs: RMCharacterCollectionViewCellViewModelWrapper) -> Bool {
            return lhs._base == rhs._base
        }
}
