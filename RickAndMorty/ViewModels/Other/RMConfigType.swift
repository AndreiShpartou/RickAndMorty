//
//  RMConfigType.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 12/07/2024.
//

import Foundation

enum RMConfigType {
    case character // name, status, gender
    case episode // name
    case location // name | type

    var endpoint: RMEndpoint {
        switch self {
        case .character:
            return .character
        case .episode:
            return .episode
        case .location:
            return .location
        }
    }

    var title: String {
        switch self {
        case .character:
            return "Search Character"
        case .episode:
            return "Search Episode"
        case .location:
            return "Search Location"
        }
    }
}
