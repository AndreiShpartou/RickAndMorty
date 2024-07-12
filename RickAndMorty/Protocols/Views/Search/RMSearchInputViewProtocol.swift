//
//  RMSearchInputViewProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 12/07/2024.
//

import UIKit

protocol RMSearchInputViewProtocol: UIView {
    var delegate: RMSearchInputViewDelegate? { get set }
    func configure(with viewModel: RMSearchInputViewViewModelProtocol)
    func presentKeyboard()
    func hideKeyboard()
    func update(option: RMDynamicOption, value: String)
}

protocol RMSearchInputViewDelegate: AnyObject {
    func rmSearchInputView(
        _ inputView: RMSearchInputViewProtocol,
        didSelectOption option: RMDynamicOption
    )

    func rmSearchInputView(
        _ inputView: RMSearchInputViewProtocol,
        didChangeSearchText text: String
    )

    func rmSearchInputViewDidTapSearchKeyboardButton(_ inputView: RMSearchInputViewProtocol)
}
