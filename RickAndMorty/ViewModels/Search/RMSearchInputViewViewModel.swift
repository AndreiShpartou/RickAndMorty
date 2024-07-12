//
//  RMSearchInputViewViewModel.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 13/06/2024.
//

import Foundation

final class RMSearchInputViewViewModel: RMSearchInputViewViewModelProtocol {

    var hasDynamicOptions: Bool {
        switch configType {
        case .character, .location:
            return true
        case .episode:
            return false
        }
    }

    var options: [RMDynamicOption] {
        switch configType {
        case .character:
            return [.status, .gender]
        case .location:
            return [.locationType]
        case .episode:
            return []
        }
    }

    var searchPlaceHolderText: String {
        switch configType {
        case .character:
            return "Character Name"
        case .location:
            return "Location Name"
        case .episode:
            return "Episode Title"
        }
    }

    private let configType: RMConfigType

    // MARK: - Init
    init(configType: RMConfigType) {
        self.configType = configType
    }
}
