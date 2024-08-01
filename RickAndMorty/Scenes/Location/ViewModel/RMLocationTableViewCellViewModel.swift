//
//  RMLocationTableViewCell.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 12/06/2024.
//

import Foundation

// MARK: - ViewModel Implementation
final class RMLocationTableViewCellViewModel: RMLocationTableViewCellViewModelProtocol {

    var name: String
    var type: String
    var dimension: String

    private let id: Int

    // MARK: - Init
    init(
        name: String,
        type: String,
        dimension: String,
        id: Int
    ) {
        self.name = name
        self.type = "Type: \(type)"
        self.dimension = dimension
        self.id = id
    }
}

// MARK: - Hashable
extension RMLocationTableViewCellViewModel: Hashable {
    static func == (lhs: RMLocationTableViewCellViewModel, rhs: RMLocationTableViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(id)
        hasher.combine(dimension)
        hasher.combine(type)
    }
}
