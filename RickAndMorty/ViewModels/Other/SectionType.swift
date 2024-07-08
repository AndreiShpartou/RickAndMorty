//
//  SectionType.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 07/07/2024.
//

import Foundation

enum SectionType {
    case photo(viewModel: RMCharacterPhotoCollectionViewCellViewModelProtocol)
    case characterInfo(viewModels: [RMCharacterInfoCollectionViewCellViewModelProtocol])
    case episodeInfo(viewModels: [RMEpisodeInfoCollectionViewCellViewModelProtocol])
    case episodes(viewModels: [RMEpisodeCollectionViewCellViewModelWrapper])
    case characters(viewModels: [RMCharacterCollectionViewCellViewModelWrapper])
}
