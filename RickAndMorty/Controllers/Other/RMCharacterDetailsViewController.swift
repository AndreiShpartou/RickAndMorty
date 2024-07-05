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

    private let viewModel: RMCharacterDetailViewViewModel
    private let detailView: RMCharacterDetailsView

    // MARK: - Init
    init(viewModel: RMCharacterDetailViewViewModel) {
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

        detailView.collectionView.delegate = self
        detailView.collectionView.dataSource = self

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
            popoverController.barButtonItem = self.navigationItem.rightBarButtonItem
        }

        self.present(activityViewController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension RMCharacterDetailsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = viewModel.sections[section]
        switch sectionType {
        case .photo:
            return Constants.numberOfItemsInSection
        case .information(let viewModels):
            return viewModels.count
        case .episodes(let viewModels):
            return viewModels.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = viewModel.sections[indexPath.section]
        switch sectionType {
        case .photo(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterPhotoCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? RMCharacterPhotoCollectionViewCell else {
                fatalError("Unable to define cell for photo")
            }
            cell.configure(with: viewModel)

            return cell
        case .information(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterInfoCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? RMCharacterInfoCollectionViewCell else {
                fatalError("Unable to define cell for info")
            }
            cell.configure(with: viewModels[indexPath.row])

            return cell
        case .episodes(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? RMCharacterEpisodeCollectionViewCell else {
                fatalError("Unable to define cell for episode")
            }
            cell.configure(with: viewModels[indexPath.row])

            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension RMCharacterDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionType = viewModel.sections[indexPath.section]
        switch sectionType {
        case .episodes:
            let episodes = self.viewModel.episodes
            let selection = episodes[indexPath.row]
            let viewController = RMEpisodeDetailsViewController(url: URL(string: selection))
            navigationController?.pushViewController(viewController, animated: true)
        default:
            break
        }
    }
}
