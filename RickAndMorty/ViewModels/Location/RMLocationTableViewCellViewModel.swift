//
//  RMLocationTableViewCell.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 12/06/2024.
//

import Foundation

// MARK: - ViewModel Implementation
final class RMLocationTableViewCellViewModel: RMLocationTableViewCellViewModelProtocol {

    var name: String {
        return location.name
    }

    var type: String {
        return "Type: " + location.type
    }

    var dimension: String {
        return location.dimension
    }

    private let location: RMLocationProtocol

    // MARK: - Init
    init(location: RMLocationProtocol) {
        self.location = location
    }
}

// MARK: - Hashable
extension RMLocationTableViewCellViewModel: Hashable {
    static func == (lhs: RMLocationTableViewCellViewModel, rhs: RMLocationTableViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(location.id)
        hasher.combine(dimension)
        hasher.combine(type)
    }
}
