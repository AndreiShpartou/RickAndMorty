//
//  RMSearchResultsView.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 15/06/2024.
//

import UIKit

// Show search results UI (table or collection as needed)
// MARK: - View Implementation
final class RMSearchResultsView: UIView {

    private let resultsHandler: RMSearchResultsHandler
    private lazy var tableView: UITableView = createTableView()
    private lazy var collectionView: UICollectionView = createCollectionView()

    // MARK: - Init
    init(resultsHandler: RMSearchResultsHandler) {
        self.resultsHandler = resultsHandler
        super.init(frame: .zero)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public
extension RMSearchResultsView: RMSearchResultsViewProtocol {
    func configure(with viewModel: RMSearchResultsViewViewModelProtocol) {
        switch viewModel.results {
        case .characters:
            setupCollectionView()
        case .episodes:
            setupCollectionView()
        case .locations:
            setupTableView()
        }
    }

    func orientationDidChange(_ notification: Notification) {
        collectionView.collectionViewLayout.invalidateLayout()
    }

    func didLoadMoreResults(with newIndexPath: [IndexPath]) {
        if !tableView.isHidden {
            tableView.tableFooterView = nil
            tableView.performBatchUpdates { [weak self] in
                self?.tableView.insertRows(at: newIndexPath, with: .automatic)
            }
        }

        if !collectionView.isHidden {
            collectionView.performBatchUpdates { [weak self] in
                self?.collectionView.insertItems(at: newIndexPath)
            }
        }
    }

    func showLoadingIndicator() {
        if !tableView.isHidden {
            let footerView = RMTableLoadingFooterView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            tableView.tableFooterView = footerView
        }
    }
}

// MARK: - Setup
extension RMSearchResultsView {
    private func setupView() {
        isHidden = true
        backgroundColor = .systemBackground
        collectionView.delegate = resultsHandler
        collectionView.dataSource = resultsHandler
        tableView.delegate = resultsHandler
        tableView.dataSource = resultsHandler
        addSubviews(tableView, collectionView)

        addConstraints()
    }

    private func setupCollectionView() {
        tableView.isHidden = true
        collectionView.isHidden = false
        collectionView.reloadData()
    }

    private func setupTableView() {
        tableView.isHidden = false
        collectionView.isHidden = true
        tableView.reloadData()
    }
}

// MARK: - Helpers
extension RMSearchResultsView {
    private func createTableView() -> UITableView {
        let table = UITableView()
        table.showsVerticalScrollIndicator = false
        table.register(
            RMLocationTableViewCell.self,
            forCellReuseIdentifier: RMLocationTableViewCell.cellIdentifier
        )
        table.isHidden = true

        return table
    }

    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isHidden = true
        collectionView.register(
            RMCharacterCollectionViewCell.self,
            forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier
        )
        collectionView.register(
            RMEpisodeCollectionViewCell.self,
            forCellWithReuseIdentifier: RMEpisodeCollectionViewCell.cellIdentifier
        )
        // Footer for loading
        collectionView.register(
            RMFooterLoadingCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier
        )

        return collectionView
    }
}

// MARK: - Constraints
extension RMSearchResultsView {
    private func addConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),

            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
