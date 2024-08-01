//
//  RMEpisodeDetailsViewProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 10/07/2024.
//

import UIKit

protocol RMEpisodeDetailsViewProtocol: UIView {
    var delegate: RMEpisodeDetailsViewDelegate? { get set }

    func didFetchEpisodeDetails()
    func createInfoLayout() -> NSCollectionLayoutSection
    func createCharacterLayout() -> NSCollectionLayoutSection
}

protocol RMEpisodeDetailsViewDelegate: AnyObject {
    func rmEpisodeDetailsView(
        _ detailsView: RMEpisodeDetailsViewProtocol,
        createLayoutFor sectionIndex: Int
    ) -> NSCollectionLayoutSection
}
