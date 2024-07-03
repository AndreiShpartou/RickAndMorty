//
//  RMSettingsCellViewViewModel.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 10/06/2024.
//

import UIKit

struct RMSettingsCellViewViewModel: Identifiable {
    let id = UUID()

    var image: UIImage? {
        return type.iconImage
    }

    var title: String {
        return type.displayTitle
    }

    var iconContainerColor: UIColor {
        return type.iconContainerColor
    }

    let onTapHandler: (RMSettingsOption) -> Void

    let type: RMSettingsOption

    // MARK: - Init
    init(type: RMSettingsOption, onTapHandler: @escaping (RMSettingsOption) -> Void) {
        self.type = type
        self.onTapHandler = onTapHandler
    }
}
