//
//  RMSearchInputViewViewModel.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 13/06/2024.
//

import Foundation

final class RMSearchInputViewViewModel {
    
    enum DynamicOption: String {
        case status = "Status"
        case gender = "Gender"
        case locationType = "Location Type"
    }
    
    // MARK: - PublicProperties
    public var hasDynamicOptions: Bool {
        switch type {
        case .character, .location:
            return true
        case .episode:
            return false
        }
    }
    
    public var options: [DynamicOption] {
        switch type {
        case .character:
            return [.status, .gender]
        case .location:
            return [.locationType]
        case .episode:
            return []
        }
    }
    
    public var searchPlaceHolderText: String {
        switch type {
        case .character:
            return "Character Name"
        case .location:
            return "Location Name"
        case .episode:
            return "Episode Title"
        }
    }
    
    // MARK: - PrivateProperties
    private let type: RMSearchViewController.Config.ConfigType
    
    // MARK: - Init
    init(type: RMSearchViewController.Config.ConfigType) {
        self.type = type
    }
    
    
}
