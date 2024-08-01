//
//  RMSearchResultsType.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 13/07/2024.
//

import Foundation

enum RMSearchResultsType {
    case characters([RMCharacterCollectionViewCellViewModelWrapper])
    case episodes([RMEpisodeCollectionViewCellViewModelWrapper])
    case locations([RMLocationTableViewCellViewModelWrapper])
}
