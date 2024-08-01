//
//  RMEpisodeCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 08/06/2024.
//

import UIKit

// MARK: - ViewModel Implementation
final class RMEpisodeCollectionViewCellViewModel: RMEpisodeCollectionViewCellViewModelProtocol {

    var name: String
    var air_date: String {
        return RMDateFormatterUtils.getShortFormattedString(from: air_dateRaw)
    }
    var episode: String
    var borderColor: UIColor

    private let episodeStringUrl: String
    private let air_dateRaw: String

    // MARK: - Init
    init(name: String, air_date: String, episode: String, borderColor: UIColor, episodeStringUrl: String) {
        self.name = name
        self.air_dateRaw = air_date
        self.episode = episode
        self.borderColor = borderColor
        self.episodeStringUrl = episodeStringUrl
    }
}

// MARK: - Hashable
extension RMEpisodeCollectionViewCellViewModel: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.episodeStringUrl)
    }

    static func == (lhs: RMEpisodeCollectionViewCellViewModel, rhs: RMEpisodeCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
