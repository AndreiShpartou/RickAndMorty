//
//  RMCharacterDetailsViewProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 07/07/2024.
//

import UIKit

protocol RMCharacterDetailsViewProtocol: UIView {
    var delegate: RMCharacterDetailsViewDelegate? { get set }
    var collectionView: UICollectionView { get }

    init(frame: CGRect, viewModel: RMCharacterDetailViewViewModelProtocol)
}

protocol RMCharacterDetailsViewDelegate: AnyObject {
    func rmCharacterListView(
        _ characterListView: RMCharacterDetailsViewProtocol,
        didSelectEpisode episodeStringURL: String
    )
}
