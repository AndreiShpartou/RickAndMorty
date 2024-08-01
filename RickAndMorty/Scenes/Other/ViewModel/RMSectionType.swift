//
//  RMSectionType.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 07/07/2024.
//

import Foundation

enum RMSectionType {
    case photo(viewModel: RMCharacterPhotoCollectionViewCellViewModelProtocol)
    case characterInfo(viewModels: [RMCharacterInfoCollectionViewCellViewModelProtocol])
    case locationInfo(viewModels: [RMEpisodeInfoCollectionViewCellViewModelProtocol])
    case episodeInfo(viewModels: [RMEpisodeInfoCollectionViewCellViewModelProtocol])
    case episodes(viewModels: [RMEpisodeCollectionViewCellViewModelWrapper])
    case characters(viewModels: [RMCharacterCollectionViewCellViewModelWrapper])
}
