//
//  RMLocationDetailsViewController.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 12/06/2024.
//

import UIKit

// View controller to show details about a single location
final class RMLocationDetailsViewController: UIViewController {

    private let viewModel: RMLocationDetailViewViewModel

    private let locationDetailView = RMLocationDetailsView()

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

        setupController()
    }
}

// MARK: - Setup
extension RMLocationDetailsViewController {
    private func setupController() {
        title = "Location"

        locationDetailView.delegate = self
        viewModel.delegate = self

        viewModel.fetchLocationData()

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShare)
        )
    }
}

// MARK: - ActionMethods
extension RMLocationDetailsViewController {
    @objc
    private func didTapShare() {
        let itemsToShare = viewModel.getDataToShare()

        let activityViewController = UIActivityViewController(
            activityItems: itemsToShare,
            applicationActivities: nil
        )
        // For iPad: Specify the location where the popover should appear
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.barButtonItem = self.navigationItem.rightBarButtonItem
        }

        self.present(activityViewController, animated: true)
    }
}

// MARK: - RMLocationDetailViewViewModelDelegate
extension RMLocationDetailsViewController: RMLocationDetailViewViewModelDelegate {
    func didFetchLocationDetail() {
        locationDetailView.configure(with: viewModel)
    }
}

// MARK: - RMLocationDetailViewDelegate
extension RMLocationDetailsViewController: RMLocationDetailsViewDelegate {
    func rmLocationDetailView(_ detailView: RMLocationDetailsView, didSelect character: RMCharacter) {
        let viewController = RMCharacterDetailsViewController(
            viewModel: .init(character: character)
        )
        viewController.title = character.name
        viewController.navigationItem.largeTitleDisplayMode = .never

        navigationController?.pushViewController(viewController, animated: true)
    }
}
