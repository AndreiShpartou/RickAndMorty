//
//  RMEpisodeCollectionViewCellViewModelProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 06/07/2024.
//

import UIKit

protocol RMEpisodeCollectionViewCellViewModelProtocol: AnyObject, Hashable {
    var borderColor: UIColor { get }
    func registerForData(_ block: @escaping (RMEpisodeDataRenderProtocol) -> Void)
    func fetchEpisode()
}

// To use this protocol without needing any keyword and suffering performance issues, create a type-erased wrapper.
// This wrapper hides the concrete type of the wrapped instance while preserving its `Hashable` conformance
final class RMEpisodeCollectionViewCellViewModelWrapper: RMEpisodeCollectionViewCellViewModelProtocol {

    var borderColor: UIColor {
        return _borderColor()
    }

    // AnyHashable to store the base object for hashable conformance
    private let _base: AnyHashable
    // Closures to pass the protocol requirements to the wrapped instance
    private let _borderColor: () -> UIColor
    private let _registerForData: (@escaping (RMEpisodeDataRenderProtocol) -> Void) -> Void
    private let _fetchEpisode: () -> Void

    init<T: RMEpisodeCollectionViewCellViewModelProtocol>(_ base: T) {
        _base = AnyHashable(base)
        _borderColor = {
            base.borderColor
        }
        _registerForData = base.registerForData
        _fetchEpisode = base.fetchEpisode
    }

    func registerForData(_ block: @escaping (RMEpisodeDataRenderProtocol) -> Void) {
        _registerForData(block)
    }

    func fetchEpisode() {
        _fetchEpisode()
    }

    func hash(into hasher: inout Hasher) {
        _base.hash(into: &hasher)
    }

    static func == (lhs: RMEpisodeCollectionViewCellViewModelWrapper, rhs: RMEpisodeCollectionViewCellViewModelWrapper) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
