//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 03/06/2024.
//

import UIKit

// Controller to show and search for Characters
// MARK: - ViewController Implementation
final class RMCharacterViewController: UIViewController {

    weak var coordinator: RMCharacterCoordinator?

    private let characterListView: RMCharacterListViewProtocol
    private let collectionHandler: RMCharacterCollectionHandler
    private let viewModel: RMCharacterListViewViewModelProtocol

    // MARK: - Init
    init(viewModel: RMCharacterListViewViewModelProtocol = RMCharacterListViewViewModel()) {
        self.collectionHandler = RMCharacterCollectionHandler(viewModel: viewModel)
        self.characterListView = RMCharacterListView(collectionHandler: collectionHandler)
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func loadView() {
        view = characterListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupController()
        addLongLivedObservers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        addShortLivedObservers()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateNavigationBar()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        removeShortLivedObservers()
    }

    deinit {
        removeLongLivedObservers()
    }
}

// MARK: - Setup
extension RMCharacterViewController {
    private func setupController() {
        title = "Characters"
        setupViewModel()
        collectionHandler.delegate = self
        addSearchButton()
        addChangeThemeButton()
    }

    private func setupViewModel() {
        viewModel.delegate = self
        viewModel.fetchCharacters()
    }

    private func addChangeThemeButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "lightbulb"),
            style: .plain,
            target: self,
            action: #selector(didTapChangeTheme)
        )
    }

    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .search,
            target: self,
            action: #selector(didTapSearch)
        )
    }

    private func addShortLivedObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(tabBarItemDoubleTapped),
            name: .tabBarItemDoubleTapped,
            object: nil
        )
    }

    private func removeShortLivedObservers() {
        NotificationCenter.default.removeObserver(
            self,
            name: .tabBarItemDoubleTapped,
            object: nil
        )
    }

    private func addLongLivedObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(orientationDidChange),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }

    private func removeLongLivedObservers() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }

    private func updateNavigationBar() {
        let isDarkMode = (self.traitCollection.userInterfaceStyle == .dark)
        let iconName = isDarkMode ? "lightbulb" : "lightbulb.fill"
        navigationItem.leftBarButtonItem?.image = UIImage(systemName: iconName)
    }
}

// MARK: - ActionMethods
extension RMCharacterViewController {
    @objc
    private func didTapSearch() {
        coordinator?.showSearchScene()
    }

    @objc
    private func didTapChangeTheme() {
        RMThemeManager().toggleTheme()
    }

    @objc
    private func tabBarItemDoubleTapped(_ notification: Notification) {
        characterListView.setNilValueForScrollOffset()
    }

    @objc
    private func orientationDidChange(_ notification: Notification) {
        characterListView.orientationDidChange()
    }
}

// MARK: - RMCharacterCollectionHandlerDelegate
extension RMCharacterViewController: RMCharacterCollectionHandlerDelegate {
    func didSelectItemAt(_ index: Int) {
        // Open detail controller for that character
        let character = viewModel.getCharacter(at: index)
        coordinator?.showCharacterDetails(for: character)
    }
}

// MARK: - RMCharacterListViewViewModelDelegate
extension RMCharacterViewController: RMCharacterListViewViewModelDelegate {
    func didLoadInitialCharacters() {
        characterListView.didLoadInitialCharacters()
    }

    func didLoadMoreCharacters(with newIndexPath: [IndexPath]) {
        characterListView.didLoadMoreCharacters(with: newIndexPath)
    }
}
