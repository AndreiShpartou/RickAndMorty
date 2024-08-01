//
//  RMSearchViewProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 12/07/2024.
//

import UIKit

protocol RMSearchViewProtocol: UIView {
    func beginSearchProcess()
    func showSearchResults()
    func showNoResults()
}
