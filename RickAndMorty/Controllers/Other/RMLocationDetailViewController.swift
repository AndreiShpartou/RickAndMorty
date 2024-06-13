//
//  RMLocationDetailViewController.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 12/06/2024.
//

import UIKit

/// View controller to show details about a single location
final class RMLocationDetailViewController: UIViewController {
    private let viewModel: RMLocationDetailViewViewModel
    
    private let locationDetailView = RMLocationDetailView()
    
    // MARK: - Init
    init(location: RMLocation) {
        let url = URL(string: location.url)
        self.viewModel = RMLocationDetailViewViewModel(endpointURL: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func loadView() {
        view = locationDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationDetailView.delegate = self
        viewModel.delegate = self

        setupView()
        viewModel.fetchLocationData()
    }
    
    // MARK: - SetupView
    private func setupView() {
        title = "Location"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShare)
        )
    }
    
    @objc
    private func didTapShare() {
        
    }
}

// MARK: - RMLocationDetailViewViewModelDelegate
extension RMLocationDetailViewController: RMLocationDetailViewViewModelDelegate {
    func didFetchLocationDetail() {
        locationDetailView.configure(with: viewModel)
    }
}

// MARK: - RMLocationDetailViewDelegate
extension RMLocationDetailViewController: RMLocationDetailViewDelegate {
    func rmLocationDetailView(_ detailView: RMLocationDetailView, didSelect character: RMCharacter) {
        let viewController = RMCharacterDetailViewController(
            viewModel: .init(character: character)
        )
        viewController.title = character.name
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
}
