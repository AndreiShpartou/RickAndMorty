//
//  RMSearchInputView.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 13/06/2024.
//

import UIKit

final class RMSearchInputView: UIView {
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        
        return searchBar
    }()
    
    private var viewModel: RMSearchInputViewViewModel? {
        didSet {
            guard let viewModel = viewModel, viewModel.hasDynamicOptions else {
                return
            }
            
            let options = viewModel.options
            createOptionSelectionViews(options: options)
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetupView
    private func setupView() {
        backgroundColor = .systemBackground
        
        addSubviews(searchBar)
        addConstraints()
    }
    
    private func createOptionSelectionViews(options: [RMSearchInputViewViewModel.DynamicOption]) {
        for option in options {
            print(option.rawValue)
        }
    }
}

// MARK: - PublicMethods
extension RMSearchInputView {
    public func configure(with viewModel: RMSearchInputViewViewModel) {
        searchBar.placeholder = viewModel.searchPlaceHolderText
        self.viewModel = viewModel
    }
}

// MARK: - Constraints
private extension RMSearchInputView {
    func addConstraints() {
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
}
