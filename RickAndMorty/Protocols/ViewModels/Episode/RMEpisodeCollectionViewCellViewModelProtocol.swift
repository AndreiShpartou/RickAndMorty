//
//  RMEpisodeCollectionViewCellViewModelProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 06/07/2024.
//

import UIKit

protocol RMEpisodeCollectionViewCellViewModelProtocol: AnyObject, Hashable {
    var name: String { get }
    var air_date: String { get }
    var episode: String { get }
    var borderColor: UIColor { get }
}

// To use this protocol without needing any keyword and suffering performance issues, create a type-erased wrapper.
// This wrapper hides the concrete type of the wrapped instance while preserving its `Hashable` conformance
final class RMEpisodeCollectionViewCellViewModelWrapper: RMEpisodeCollectionViewCellViewModelProtocol {

    var name: String {
        return _name()
    }

    var air_date: String {
        return _air_date()
    }

    var episode: String {
        return _episode()
    }

    var borderColor: UIColor {
        return _borderColor()
    }

    // AnyHashable to store the base object for hashable conformance
    private let _base: AnyHashable
    // Closures to pass the protocol requirements to the wrapped instance
    private let _name: () -> String
    private let _air_date: () -> String
    private let _episode: () -> String
    private let _borderColor: () -> UIColor

    init<T: RMEpisodeCollectionViewCellViewModelProtocol>(_ base: T) {
        _base = AnyHashable(base)

        _name = {
            base.name
        }

        _air_date = {
            base.air_date
        }

        _episode = {
            base.episode
        }

        _borderColor = {
            base.borderColor
        }
    }

    func hash(into hasher: inout Hasher) {
        _base.hash(into: &hasher)
    }

    static func == (lhs: RMEpisodeCollectionViewCellViewModelWrapper, rhs: RMEpisodeCollectionViewCellViewModelWrapper) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
