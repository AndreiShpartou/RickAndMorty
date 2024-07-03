//
//  RMLocationTableViewCell.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 12/06/2024.
//

import Foundation

struct RMLocationTableViewCellViewModel {

    var name: String {
        return location.name
    }

    var type: String {
        return "Type: " + location.type
    }

    var dimension: String {
        return location.dimension
    }

    private let location: RMLocation

    // MARK: - Init
    init(location: RMLocation) {
        self.location = location
    }
}

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
