//
//  RMSearchResultsView.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 15/06/2024.
//

import UIKit

protocol RMSearchResultsViewDelegate: AnyObject {
    func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapLocationAt index: Int)
}

/// Show search results UI (table or collection as needed)
final class RMSearchResultsView: UIView {
    
    weak var delegate: RMSearchResultsViewDelegate?
    
    private var viewModel: RMSearchResultViewModel? {
        didSet {
            self.processViewModel()
        }
    }
    
    private var locationTableViewCellViewModels: [RMLocationTableViewCellViewModel] = []
    
    private var tableView: UITableView = {
        let table = UITableView()
        table.register(
            RMLocationTableViewCell.self,
            forCellReuseIdentifier: RMLocationTableViewCell.cellIdentifier
        )
        table.isHidden = true
        
        return table
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetupView
    private func setupView() {
        isHidden = true
        backgroundColor = .systemBackground
        addSubviews(tableView)
        
        addConstraints()
    }
    
    private func processViewModel() {
        guard let viewModel = viewModel else {
            return
        }
        
        switch viewModel {
        case .characters(let viewModels):
            setupCollectionView()
        case .episodes(let viewModels):
            setupCollectionView()
        case .locations(let viewModels):
            setupTableView(with: viewModels)
        }
    }
    
    private func setupCollectionView() {
        
    }
    
    private func setupTableView(with viewModels: [RMLocationTableViewCellViewModel]) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = false
        self.locationTableViewCellViewModels = viewModels
        tableView.reloadData()
    }
}

// MARK: - Public
extension RMSearchResultsView {
    public func configure(with viewModel: RMSearchResultViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - UITableViewDataSource
extension RMSearchResultsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationTableViewCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RMLocationTableViewCell.cellIdentifier,
            for: indexPath
        ) as? RMLocationTableViewCell else {
            fatalError("Failed to dequeue RMLocationTableViewCell")
        }
        cell.configure(with: locationTableViewCellViewModels[indexPath.row])
        
        return cell
    }
    
    
}

// MARK: - UITableViewDelegate
extension RMSearchResultsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.rmSearchResultsView(self, didTapLocationAt: indexPath.row)
    }
}

// MARK: - Constraints
private extension RMSearchResultsView {
    private func addConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
