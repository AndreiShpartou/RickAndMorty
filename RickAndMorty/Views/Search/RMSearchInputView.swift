//
//  RMSearchInputView.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 13/06/2024.
//

import UIKit

// View for top part of screen with search bar
// MARK: - View Implementation
final class RMSearchInputView: UIView {

    weak var delegate: RMSearchInputViewDelegate?

    private lazy var searchBar: UISearchBar = createSearchBar()
    private var stackView: UIStackView?

    private var options: [RMDynamicOption]?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - RMSearchInputViewProtocol
extension RMSearchInputView: RMSearchInputViewProtocol {
    func configure(with viewModel: RMSearchInputViewViewModelProtocol) {
        guard viewModel.hasDynamicOptions else {
            return
        }

        createOptionSelectionViews(options: viewModel.options)
        self.options = viewModel.options

        searchBar.placeholder = viewModel.searchPlaceHolderText
    }

    func presentKeyboard() {
        if let inputText = searchBar.text,
           inputText.isEmpty {
            searchBar.becomeFirstResponder()
        }
    }

    func hideKeyboard() {
        if let inputText = searchBar.text,
           !inputText.isEmpty {
            searchBar.resignFirstResponder()
        }
    }

    func update(option: RMDynamicOption, value: String) {
        // Update options
        guard let buttons = stackView?.arrangedSubviews as? [UIButton],
              let options = options,
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

// MARK: - Setup
extension RMSearchInputView {
    private func setupView() {
        backgroundColor = .systemBackground

        addSubviews(searchBar)
        searchBar.delegate = self

        addConstraints()
    }

    private func createOptionSelectionViews(options: [RMDynamicOption]) {
        let stackView = createOptionStackView()
        self.stackView = stackView

        for index in 0..<options.count {
            let option = options[index]
            let button = createButton(with: option, tag: index)
            stackView.addArrangedSubview(button)
        }
    }
}

// MARK: - ActionMethods
extension RMSearchInputView {
    @objc
    private func didTapButton(_ sender: UIButton) {
        guard let options = options else {
            return
        }

        let tag = sender.tag
        let selected = options[tag]

        delegate?.rmSearchInputView(self, didSelectOption: selected)
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

// MARK: - Helpers
extension RMSearchInputView {
    private func createSearchBar() -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"

        return searchBar
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
        with option: RMDynamicOption,
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
}

// MARK: - Constraints
extension RMSearchInputView {
    private func addConstraints() {
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 55)
        ])
    }

    private func addStackViewConstraints(to stackView: UIStackView) {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
