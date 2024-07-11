//
//  RMLocationTableViewCellViewModelProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 11/07/2024.
//

import Foundation

protocol RMLocationTableViewCellViewModelProtocol: Hashable {
    var name: String { get }
    var type: String { get }
    var dimension: String { get }
}

// To use this protocol without needing any keyword and suffering performance issues, create a type-erased wrapper.
// This wrapper hides the concrete type of the wrapped instance while preserving its `Hashable` conformance
final class RMLocationTableViewCellViewModelWrapper: RMLocationTableViewCellViewModelProtocol {

    var name: String {
        return _name()
    }
    var type: String {
        return _type()
    }
    var dimension: String {
        return _dimension()
    }

    // AnyHashable to store the base object for hashable conformance
    private let _base: AnyHashable
    // Closures to pass the protocol requirements to the wrapped instance
    private let _name: () -> String
    private let _type: () -> String
    private let _dimension: () -> String

    init<T: RMLocationTableViewCellViewModelProtocol>(_ base: T) {
        _base = AnyHashable(base)
        _name = {
            base.name
        }
        _type = {
            base.type
        }
        _dimension = {
            base.dimension
        }
    }

    func hash(into hasher: inout Hasher) {
        _base.hash(into: &hasher)
    }

    static func == (lhs: RMLocationTableViewCellViewModelWrapper, rhs: RMLocationTableViewCellViewModelWrapper) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
