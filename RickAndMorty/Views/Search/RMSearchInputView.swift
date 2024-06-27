//
//  RMSearchInputView.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 13/06/2024.
//

import UIKit

protocol RMSearchInputViewDelegate: AnyObject {
    func rmSearchInputView(
        _ inputView: RMSearchInputView,
        didSelectOption option: RMSearchInputViewViewModel.DynamicOption
    )
    
    func rmSearchInputView(
        _ inputView: RMSearchInputView,
        didChangeSearchText text: String
    )
    
    func rmSearchInputViewDidTapSearchKeyboardButton(_ inputView: RMSearchInputView)
}

/// View for top part of screen with search bar
final class RMSearchInputView: UIView {
    weak var delegate: RMSearchInputViewDelegate?
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        
        return searchBar
    }()
    
    private var stackView: UIStackView?
    
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
        
        searchBar.delegate = self
    }
    
    private func createOptionStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        addSubviews(stackView)
        addStackViewConstraints(to: stackView)
        
        return stackView
    }
    
    private func createButton(
        with option: RMSearchInputViewViewModel.DynamicOption,
        tag: Int
    ) -> UIButton {
        
        let button = UIButton()
        button.setAttributedTitle(
            NSAttributedString(
                string: option.rawValue,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 18, weight: .medium),
                    .foregroundColor: UIColor.label
                ]
            ),
            for: .normal
        )
        button.backgroundColor = .secondarySystemBackground
        button.layer.cornerRadius = 5
        button.tag = tag
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        return button
    }
    
    private func createOptionSelectionViews(options: [RMSearchInputViewViewModel.DynamicOption])  {
        let stackView = createOptionStackView()
        self.stackView = stackView
        
        for index in 0..<options.count {
            let option = options[index]
            let button = createButton(with: option, tag: index)
            stackView.addArrangedSubview(button)
        }
        
    }
    
    // MARK: - ActionMethods
    @objc
    private func didTapButton(_ sender: UIButton) {
        guard let options = viewModel?.options else {
            return
        }
        
        let tag = sender.tag
        let selected = options[tag]
        
        delegate?.rmSearchInputView(self, didSelectOption: selected)
    }
}

// MARK: - PublicMethods
extension RMSearchInputView {
    
    public func configure(with viewModel: RMSearchInputViewViewModel) {
        searchBar.placeholder = viewModel.searchPlaceHolderText
        self.viewModel = viewModel
    }
    
    public func presentKeyboard() {
        if let inputText = searchBar.text,
           inputText.isEmpty {
            searchBar.becomeFirstResponder()
        }
    }
    
    public func hideKeyboard() {
        if let inputText = searchBar.text,
           !inputText.isEmpty {
            searchBar.resignFirstResponder()
        }
    }

    public func update(option: RMSearchInputViewViewModel.DynamicOption, value: String) {
        // Update options
        guard let buttons = stackView?.arrangedSubviews as? [UIButton],
              let options = viewModel?.options,
              let index = options.firstIndex(of: option) else {
            return
        }
        
        buttons[index].setAttributedTitle(
            NSAttributedString(
                string: value.uppercased(),
                attributes: [
                    .font: UIFont.systemFont(ofSize: 18, weight: .medium),
                    .foregroundColor: UIColor.link
                ]
            ),
            for: .normal
        )
    }
}

// MARK: - UISearchBarDelegate
extension RMSearchInputView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Notify delegate of change text
        delegate?.rmSearchInputView(self, didChangeSearchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Notify that search button was tapped
        searchBar.resignFirstResponder()
        delegate?.rmSearchInputViewDidTapSearchKeyboardButton(self)
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
    
    func addStackViewConstraints(to stackView: UIStackView) {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
