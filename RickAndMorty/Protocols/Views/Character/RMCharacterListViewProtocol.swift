//
//  RMCharacterListViewProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 04/07/2024.
//

import UIKit

protocol RMCharacterListViewProtocol: UIView {
    func setNilValueForScrollOffset()
    func didLoadInitialCharacters()
    func didLoadMoreCharacters(with newIndexPath: [IndexPath])
    func orientationDidChange()
}
