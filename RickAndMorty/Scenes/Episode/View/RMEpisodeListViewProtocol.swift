//
//  RMEpisodeListViewProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 10/07/2024.
//

import UIKit

protocol RMEpisodeListViewProtocol: UIView {
    func setNilValueForScrollOffset()
    func didLoadInitialEpisodes()
    func didLoadMoreEpisodes(with newIndexPath: [IndexPath])
    func orientationDidChange()
}
