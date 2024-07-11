//
//  RMLocationViewProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 11/07/2024.
//

import UIKit

protocol RMLocationViewProtocol: UIView {
    func setNilValueForScrollOffset()
    func didLoadInitialLocations()
    func didLoadMoreLocations()
    func showLoadingIndicator()
}
