//
//  RMEpisodeDetailsViewController.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 08/06/2024.
//

import UIKit

// View controller to show details about a single episode
// MARK: - ViewController Implementation
final class RMEpisodeDetailsViewController: UIViewController {

    weak var coordinator: RMDetailsCoordinator?

    private let detailsView: RMEpisodeDetailsViewProtocol
    private let collectionHandler: RMEpisodeDetailsCollectionHandler
    private let viewModel: RMEpisodeDetailsViewViewModelProtocol

    // MARK: - Init
    init(viewModel: RMEpisodeDetailsViewViewModelProtocol) {
        self.viewModel = viewModel
        self.collectionHandler = RMEpisodeDetailsCollectionHandler(viewModel: viewModel)
        self.detailsView = RMEpisodeDetailsView(collectionHandler: collectionHandler)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func loadView() {
        view = detailsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupController()
    }
}

// MARK: - Setup
extension RMEpisodeDetailsViewController {
    private func setupController() {
        title = "Episode"

        detailsView.delegate = self
        collectionHandler.delegate = self
        setupViewModel()

        addShareButton()
    }

    private func setupViewModel() {
        viewModel.delegate = self
        viewModel.fetchEpisodeData()
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
extension RMEpisodeDetailsViewController {
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

// MARK: - RMEpisodeDetailViewDelegate
extension RMEpisodeDetailsViewController: RMEpisodeDetailsViewDelegate {
    func rmEpisodeDetailsView(_ detailsView: RMEpisodeDetailsViewProtocol, createLayoutFor sectionIndex: Int) -> NSCollectionLayoutSection {
        let sectionTypes = viewModel.sections
        switch sectionTypes[sectionIndex] {
        case .episodeInfo:
            return detailsView.createInfoLayout()
        case .characters:
            return detailsView.createCharacterLayout()
        default:
            fatalError("Unacceptable section type!")
        }
    }
}

// MARK: - RMEpisodeDetailsCollectionHandlerDelegate
extension RMEpisodeDetailsViewController: RMEpisodeDetailsCollectionHandlerDelegate {
    func didSelectItemAt(_ section: Int, _ index: Int) {
        let sectionType = viewModel.sections[section]
        if case .characters = sectionType {
            guard let character = viewModel.getCharacter(at: index) else {
                return
            }

            coordinator?.showCharacterDetails(for: character)
        }
    }
}

extension RMEpisodeDetailsViewController: RMEpisodeDetailsViewViewModelDelegate {
    func didFetchEpisodeDetails() {
        detailsView.didFetchEpisodeDetails()
    }
}
