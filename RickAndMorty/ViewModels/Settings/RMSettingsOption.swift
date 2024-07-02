//
//  RMSettingsOption.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 10/06/2024.
//

import UIKit

enum RMSettingsOption: CaseIterable {
    case rateApp
    case contactUs
    case apiReference
    case viewSeries
    case viewCode

    var targetUrl: URL? {
        switch self {
        case .rateApp:
            return nil
        case .contactUs:
            return URL(string: "https://github.com/AndreiShpartou")
        case .apiReference:
            return URL(string: "https://rickandmortyapi.com")
        case .viewSeries:
            return URL(string: "https://stage.rickandmorty.com/videos")
        case .viewCode:
            return URL(string: "https://github.com/AndreiShpartou/RickAndMorty")
        }
    }

    var displayTitle: String {
        switch self {
        case .rateApp:
            return "Rate App"
        case .contactUs:
            return "Contact Us"
        case .apiReference:
            return "API Reference"
        case .viewSeries:
            return "View video Series"
        case .viewCode:
            return "View App Code"
        }
    }

    var iconContainerColor: UIColor {
        switch self {
        case .rateApp:
            return .systemBlue
        case .contactUs:
            return .systemGreen
        case .apiReference:
            return .systemCyan
        case .viewSeries:
            return .systemTeal
        case .viewCode:
            return .systemPink
        }
    }

    var iconImage: UIImage? {
        switch self {
        case .rateApp:
            return UIImage(systemName: "star.fill")
        case .contactUs:
            return UIImage(systemName: "paperplane")
        case .apiReference:
            return UIImage(systemName: "list.and.film")
        case .viewSeries:
            return UIImage(systemName: "tv.fill")
        case .viewCode:
            return UIImage(systemName: "hammer.fill")
        }
    }
}
