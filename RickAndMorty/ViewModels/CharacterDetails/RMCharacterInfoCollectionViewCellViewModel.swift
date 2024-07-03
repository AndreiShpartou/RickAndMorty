//
//  RMCharacterInfoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 08/06/2024.
//

import UIKit

final class RMCharacterInfoCollectionViewCellViewModel {

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.SSSSZ"
        formatter.timeZone = .current

        return formatter
    }()

    static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.timeZone = .current

        return formatter
    }()

    enum InfoType: String {
        case status
        case gender
        case type
        case species
        case origin
        case created
        case location
        case episodeCount

        var tintColor: UIColor {
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

        var iconImage: UIImage? {
            switch self {
            case .status:
                return UIImage(systemName: "bell")
            case .gender:
                return UIImage(systemName: "bell")
            case .type:
                return UIImage(systemName: "bell")
            case .species:
                return UIImage(systemName: "bell")
            case .origin:
                return UIImage(systemName: "bell")
            case .created:
                return UIImage(systemName: "bell")
            case .location:
                return UIImage(systemName: "bell")
            case .episodeCount:
                return UIImage(systemName: "bell")
            }
        }

        var displayTitle: String {
            switch self {
            case .episodeCount:
                return "EPISODE COUNT"
            default:
                return rawValue.uppercased()
            }
        }
    }

    var title: String {
        return type.displayTitle
    }

    var displayValue: String {
        if value.isEmpty {
            return "None"
        }

        if type == .created,
           let date = Self.dateFormatter.date(from: value) {
            return Self.shortDateFormatter.string(from: date)
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
