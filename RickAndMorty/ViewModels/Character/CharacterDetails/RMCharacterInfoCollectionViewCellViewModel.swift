//
//  RMCharacterInfoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 08/06/2024.
//

import UIKit

// MARK: - ViewModel Implementation
// Type of RMCharacterInfoCollectionViewCellViewModel
enum InfoType: String {
    case status
    case gender
    case type
    case species
    case origin
    case created
    case location
    case episodeCount

    fileprivate var tintColor: UIColor {
        switch self {
        case .status:
            return .systemBlue
        case .gender:
            return .systemRed
        case .type:
            return .systemPurple
        case .species:
            return .systemGreen
        case .origin:
            return .systemOrange
        case .created:
            return .systemPink
        case .location:
            return .systemYellow
        case .episodeCount:
            return .systemMint
        }
    }

    fileprivate var iconImage: UIImage? {
        return UIImage(systemName: "bell")
    }

    fileprivate var displayTitle: String {
        switch self {
        case .episodeCount:
            return "EPISODE COUNT"
        default:
            return rawValue.uppercased()
        }
    }
}

final class RMCharacterInfoCollectionViewCellViewModel: RMCharacterInfoCollectionViewCellViewModelProtocol {

    var title: String {
        return type.displayTitle
    }

    var displayValue: String {
        if value.isEmpty {
            return "None"
        }

        if type == .created,
           let date = RMDateFormatterUtils.formatter.date(from: value) {
            return RMDateFormatterUtils.shortFormatter.string(from: date)
        }

        return value
    }

    var iconImage: UIImage? {
        return type.iconImage
    }

    var tintColor: UIColor {
        return type.tintColor
    }

    private var type: InfoType
    private let value: String

    // MARK: - Init
    init(type: InfoType, value: String) {
        self.type = type
        self.value = value
    }
}
