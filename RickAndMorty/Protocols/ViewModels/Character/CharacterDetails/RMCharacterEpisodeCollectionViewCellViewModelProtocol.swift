//
//  RMCharacterEpisodeCollectionViewCellViewModelProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 06/07/2024.
//

import UIKit

protocol RMCharacterEpisodeCollectionViewCellViewModelProtocol: AnyObject, Hashable {
    var borderColor: UIColor { get }
    func registerForData(_ block: @escaping (RMEpisodeDataRenderProtocol) -> Void)
    func fetchEpisode()
}
