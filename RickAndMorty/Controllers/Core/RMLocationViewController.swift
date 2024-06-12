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

    // MARK: - LifeCycle
    override func loadView() {
        view = locationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Locations"
        addSearchButton()
    }
    
    // MARK: - Private Methods
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .search,
            target: self,
            action: #selector(didTapSearch)
        )
    }
    
    @objc private func didTapSearch() {
        
    }
}
