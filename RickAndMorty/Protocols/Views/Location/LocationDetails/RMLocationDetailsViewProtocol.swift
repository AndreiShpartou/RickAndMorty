//
//  RMLocationDetailsViewProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 11/07/2024.
//

import UIKit

protocol RMLocationDetailsViewProtocol: UIView {
    var delegate: RMLocationDetailsViewDelegate? { get set }

    func didFetchLocationDetails()
    func createInfoLayout() -> NSCollectionLayoutSection
    func createCharacterLayout() -> NSCollectionLayoutSection
}

protocol RMLocationDetailsViewDelegate: AnyObject {
    func rmLocationDetailsView(
        _ detailsView: RMLocationDetailsViewProtocol,
        createLayoutFor sectionIndex: Int
    ) -> NSCollectionLayoutSection
}
