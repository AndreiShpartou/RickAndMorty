//
//  RMLocationViewController.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 03/06/2024.
//

import UIKit

// Controller to show and search for Locations
// MARK: - ViewController Implementation
final class RMLocationViewController: UIViewController {

    private let locationView: RMLocationViewProtocol
    private let tableViewHandler: RMLocationTableViewHandler
    private var viewModel: RMLocationViewViewModelProtocol

    // MARK: - Init
    init(viewModel: RMLocationViewViewModelProtocol = RMLocationViewViewModel()) {
        self.tableViewHandler = RMLocationTableViewHandler(viewModel: viewModel)
        self.locationView = RMLocationView(tableViewHandler: tableViewHandler)
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func loadView() {
        view = locationView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        addObservers()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateNavigationBar()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        removeObservers()
    }
}

// MARK: - Setup
extension RMLocationViewController {
    private func setupController() {
        title = "Locations"
        tableViewHandler.delegate = self
        setupViewModel()
        addSearchButton()
        addChangeThemeButton()
    }

    private func setupViewModel() {
        viewModel.delegate = self
        viewModel.fetchLocations()
    }

    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .search,
            target: self,
            action: #selector(didTapSearch)
        )
    }

    private func addChangeThemeButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "lightbulb"),
            style: .plain,
            target: self,
            action: #selector(didTapChangeTheme)
        )
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(tabBarItemDoubleTapped),
            name: .tabBarItemDoubleTapped,
            object: nil
        )
    }

    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: .tabBarItemDoubleTapped, object: nil)
    }

    private func updateNavigationBar() {
        let isDarkMode = (self.traitCollection.userInterfaceStyle == .dark)
        let iconName = isDarkMode ? "lightbulb" : "lightbulb.fill"
        navigationItem.leftBarButtonItem?.image = UIImage(systemName: iconName)
    }
}

// MARK: - ActionMethods
extension RMLocationViewController {
    @objc
    private func didTapSearch() {
        let viewController = RMSearchViewController(configType: .location)
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc
    private func didTapChangeTheme() {
        RMThemeManager.shared.toggleTheme()
    }

    @objc
    private func tabBarItemDoubleTapped(_ notification: Notification) {
        locationView.setNilValueForScrollOffset()
    }
}

// MARK: - RMLocationTableViewHandlerDelegate
extension RMLocationViewController: RMLocationTableViewHandlerDelegate {
    func didSelectItemAt(_ index: Int) {
        // Open detail controller for location
        let location = viewModel.getLocation(at: index)
        let viewModel = RMLocationDetailsViewViewModel(location: location)
        let detailVC = RMLocationDetailsViewController(viewModel: viewModel)
        detailVC.navigationItem.largeTitleDisplayMode = .never

        navigationController?.pushViewController(detailVC, animated: true)
    }

    func showLoadingIndicator() {
        locationView.showLoadingIndicator()
    }
}

// MARK: - RMLocationViewViewModelDelegate
extension RMLocationViewController: RMLocationViewViewModelDelegate {

    func didLoadInitialLocations() {
        locationView.didLoadInitialLocations()
    }

    func didLoadMoreLocations() {
        locationView.didLoadMoreLocations()
    }
}
