//
//  RMSearchResultsView.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 15/06/2024.
//

import UIKit

/// Show search results UI (table or collection as needed)
final class RMSearchResultsView: UIView {
    
    private var viewModel: RMSearchResultViewModel? {
        didSet {
            self.processViewModel()
        }
    }
    
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
            setupTableView()
        }
    }
    
    private func setupCollectionView() {
        
    }
    
    private func setupTableView() {
        tableView.isHidden = false
    }
}

// MARK: - Public
extension RMSearchResultsView {
    public func configure(with viewModel: RMSearchResultViewModel) {
        self.viewModel = viewModel
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
        tableView.backgroundColor = .yellow
    }
}
