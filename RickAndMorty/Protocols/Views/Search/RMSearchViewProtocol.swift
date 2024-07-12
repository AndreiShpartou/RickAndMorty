//
//  RMSearchViewProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 12/07/2024.
//

import Foundation

protocol RMSearchViewProtocol {
    var delegate: RMSearchViewDelegate? { get set }

    func presentKeyboard()
    func hideKeyboard()
    func orientationDidChange(_ notification: Notification)
    func beginSearchProcess()
    func optionBlockDidChange(with tuple: (RMDynamicOption, String))
    func showSearchResults(for: RMSearchResultsViewViewModel)
    func showNoResults()
}

protocol RMSearchViewDelegate: AnyObject, RMSearchInputViewDelegate, RMSearchResultsViewDelegate {
}
