//
//  RMCharacterDetailsViewProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 07/07/2024.
//

import UIKit

protocol RMCharacterDetailsViewProtocol: UIView {
    var delegate: RMCharacterDetailsViewDelegate? { get set }

    func createPhotoSectionLayout() -> NSCollectionLayoutSection
    func createInfoSectionLayout() -> NSCollectionLayoutSection
    func createEpisodeSectionLayout() -> NSCollectionLayoutSection
}

protocol RMCharacterDetailsViewDelegate: AnyObject {
    func rmCharacterListView(
        _ characterDetailsView: RMCharacterDetailsViewProtocol,
        createLayoutFor sectionIndex: Int
    ) -> NSCollectionLayoutSection
}
