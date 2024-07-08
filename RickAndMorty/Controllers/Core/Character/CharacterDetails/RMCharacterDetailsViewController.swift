//
//  RMCharacterDetailsViewController.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 06/06/2024.
//

import UIKit

// View controller to show details about a single character
// MARK: - ViewController Implementation
class RMCharacterDetailsViewController: UIViewController {

    private let viewModel: RMCharacterDetailViewViewModelProtocol
    private let detailView: RMCharacterDetailsViewProtocol

    // MARK: - Init
    init(viewModel: RMCharacterDetailViewViewModelProtocol) {
        self.viewModel = viewModel
        self.detailView = RMCharacterDetailsView(
            frame: .zero,
            viewModel: viewModel
        )

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func loadView() {
        view = detailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupController()
    }
}

// MARK: - Setup
extension RMCharacterDetailsViewController {
    private func setupController() {
        title = viewModel.title

        detailView.delegate = self
        addShareButton()
    }

    private func addShareButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShare)
        )
    }
}

// MARK: - ActionMethods
extension RMCharacterDetailsViewController {
    @objc
    private func didTapShare() {
        let itemsToShare = viewModel.getDataToShare()

        let activityViewController = UIActivityViewController(
            activityItems: itemsToShare,
            applicationActivities: nil
        )
        // For iPad: Specify the location where the popover should appear
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.barButtonItem = navigationItem.rightBarButtonItem
        }

        present(activityViewController, animated: true)
    }
}

// MARK: - RMCharacterDetailsViewDelegate
extension RMCharacterDetailsViewController: RMCharacterDetailsViewDelegate {
    func rmCharacterListView(_ characterListView: RMCharacterDetailsViewProtocol, didSelectEpisode episodeStringURL: String) {
        let episodeVC = RMEpisodeDetailsViewController(url: URL(string: episodeStringURL))
        navigationController?.pushViewController(episodeVC, animated: true)
    }
}
