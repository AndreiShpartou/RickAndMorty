//
//  RMLocationViewController.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 03/06/2024.
//

import UIKit

/// Controller to show and search for Locations
final class RMLocationViewController: UIViewController {
    
    private let locationView = RMLocationView()
    
    private let viewModel = RMLocationViewViewModel()
    
    // MARK: - DeInit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - LifeCycle
    override func loadView() {
        view = locationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Locations"
        addSearchButton()
        
        locationView.delegate = self
        viewModel.delegate = self
        viewModel.fetchLocations()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(tabBarItemDoubleTapped),
            name: .tabBarItemDoubleTapped,
            object: nil
        )
    }
    
    // MARK: - Private Methods
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .search,
            target: self,
            action: #selector(didTapSearch)
        )
    }
    
    @objc
    private func tabBarItemDoubleTapped(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let viewController = userInfo["viewController"] as? UIViewController else {
            return
        }
        
        if viewController == self {
            locationView.setNilValueForScrollOffset()
        }
    }
    
    @objc private func didTapSearch() {
        let viewController = RMSearchViewController(config: .init(type: .location))
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - RMLocationViewDelegate
extension RMLocationViewController: RMLocationViewDelegate {
    func rmLocationView(_ locationView: RMLocationView, didSelect location: RMLocation) {
        let viewController = RMLocationDetailsViewController(location: location)
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - RMLocationViewViewModelDelegate
extension RMLocationViewController: RMLocationViewViewModelDelegate {
    func didFetchInitialLocations() {
        locationView.configure(with: viewModel)
    }
}


