//
//  RMCharacterListViewProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 04/07/2024.
//

import UIKit

protocol RMCharacterListViewProtocol: UIView {
    var delegate: RMCharacterListViewDelegate? { get set }
    func setNilValueForScrollOffset()
}

protocol RMCharacterListViewDelegate: AnyObject {
    func rmCharacterListView(
        _ characterListView: RMCharacterListViewProtocol,
        didSelectCharacter character: RMCharacter
    )
}
