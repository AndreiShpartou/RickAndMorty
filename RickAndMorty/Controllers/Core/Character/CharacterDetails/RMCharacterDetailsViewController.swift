//
//  RMCharacterDetailsViewController.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 06/06/2024.
//

import UIKit

// View controller to show details about a single character
// MARK: - ViewController Implementation
final class RMCharacterDetailsViewController: UIViewController {

    weak var coordinator: RMDetailsCoordinator?

    private let detailsView: RMCharacterDetailsViewProtocol
    private let collectionHandler: RMCharacterDetailsCollectionHandler
    private let viewModel: RMCharacterDetailsViewViewModelProtocol

    // MARK: - Init
    init(viewModel: RMCharacterDetailsViewViewModelProtocol) {
        self.viewModel = viewModel
        self.collectionHandler = RMCharacterDetailsCollectionHandler(viewModel: viewModel)
        self.detailsView = RMCharacterDetailsView(collectionHandler: collectionHandler)

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
extension RMCharacterDetailsViewController {
    private func setupController() {
        title = viewModel.title

        detailsView.delegate = self
        collectionHandler.delegate = self
        setupViewModel()
        addShareButton()
    }

    private func setupViewModel() {
        viewModel.delegate = self
        viewModel.fetchCharacterData()
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
    func rmCharacterDetailsView(_ characterDetailsView: RMCharacterDetailsViewProtocol, createLayoutFor sectionIndex: Int) -> NSCollectionLayoutSection {
        let sectionTypes = viewModel.sections
        switch sectionTypes[sectionIndex] {
        case .photo:
            return characterDetailsView.createPhotoSectionLayout()
        case .characterInfo:
            return characterDetailsView.createInfoSectionLayout()
        case .episodes:
            return characterDetailsView.createEpisodeSectionLayout()
        default:
            fatalError("Unacceptable section type!")
        }
    }
}

// MARK: - RMCharacterDetailsCollectionHandlerDelegate
extension RMCharacterDetailsViewController: RMCharacterDetailsCollectionHandlerDelegate {
    func didSelectItemAt(_ section: Int, _ index: Int) {
        let sectionType = viewModel.sections[section]
        if case .episodes = sectionType {
            let episode = viewModel.getEpisode(at: index)
            guard let episode = episode else {
                return
            }

            coordinator?.showEpisodeDetails(for: episode)
        }
    }
}

// MARK: - RMCharacterDetailsViewViewModelDelegate
extension RMCharacterDetailsViewController: RMCharacterDetailsViewViewModelDelegate {
    func didFetchCharacterDetails() {
        detailsView.didFetchCharactersDetails()
    }
}
