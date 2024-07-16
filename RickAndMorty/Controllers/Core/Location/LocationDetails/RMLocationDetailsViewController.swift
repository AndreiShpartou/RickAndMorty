//
//  RMLocationDetailsViewController.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 12/06/2024.
//

import UIKit

protocol RMLocationDetailsViewControllerDelegate: AnyObject {
    func didSelectCharacter(_ character: RMCharacterProtocol)
}

// View controller to show details about a single location
// MARK: - ViewController Implementation
final class RMLocationDetailsViewController: UIViewController {

    weak var delegate: RMLocationDetailsViewControllerDelegate?

    private let detailsView: RMLocationDetailsViewProtocol
    private let collectionHandler: RMLocationDetailsCollectionHandler
    private let viewModel: RMLocationDetailsViewViewModelProtocol

    // MARK: - Init
    init(viewModel: RMLocationDetailsViewViewModelProtocol) {
        self.viewModel = viewModel
        self.collectionHandler = RMLocationDetailsCollectionHandler(viewModel: viewModel)
        self.detailsView = RMLocationDetailsView(collectionHandler: collectionHandler)

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
extension RMLocationDetailsViewController {
    private func setupController() {
        title = "Location"

        detailsView.delegate = self
        collectionHandler.delegate = self
        setupViewModel()

        addShareButton()
    }

    private func setupViewModel() {
        viewModel.delegate = self
        viewModel.fetchLocationData()
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

// MARK: - RMLocationDetailViewDelegate
extension RMLocationDetailsViewController: RMLocationDetailsViewDelegate {
    func rmLocationDetailsView(_ detailsView: RMLocationDetailsViewProtocol, createLayoutFor sectionIndex: Int) -> NSCollectionLayoutSection {
        switch viewModel.sections[sectionIndex] {
        case .locationInfo:
            return detailsView.createInfoLayout()
        case .characters:
            return detailsView.createCharacterLayout()
        default:
            fatalError("Unacceptable section type!")
        }
    }
}

// MARK: - RMLocationDetailsCollectionHandlerDelegate
extension RMLocationDetailsViewController: RMLocationDetailsCollectionHandlerDelegate {
    func didSelectItemAt(_ section: Int, _ index: Int) {
        let sectionType = viewModel.sections[section]
        if case .characters = sectionType {
            guard let character = viewModel.character(at: index) else {
                return
            }

            delegate?.didSelectCharacter(character)
        }
    }
}

// MARK: - RMLocationDetailViewViewModelDelegate
extension RMLocationDetailsViewController: RMLocationDetailsViewViewModelDelegate {
    func didFetchLocationDetail() {
        detailsView.didFetchLocationDetails()
    }
}
