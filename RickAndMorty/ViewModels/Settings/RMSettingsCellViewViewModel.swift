//
//  RMSettingsCellViewViewModel.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 10/06/2024.
//

import UIKit

struct RMSettingsCellViewViewModel: Identifiable, Hashable {
    let id = UUID()
    
    public var image: UIImage? {
        return type.iconImage
    }
    public var title: String {
        return type.displayTitle
    }
    public var iconContainerColor: UIColor {
        return type.iconContainerColor
    }
    
    private let type: RMSettingsOption
    
    // MARK: - Init
    init(type: RMSettingsOption) {
        self.type = type
    }
}
