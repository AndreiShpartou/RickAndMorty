//
//  RMLocationView.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 12/06/2024.
//

import UIKit

final class RMLocationView: UIView {

    // MARK: - Properties
    private var viewModel: RMLocationViewViewModel? {
        didSet {
            spinner.stopAnimating()
            tableView.isHidden = false
            tableView.reloadData()
            UIView.animate(withDuration: 0.3) {
                self.tableView.alpha = 1
            }
        }
    }
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.alpha = 0
        table.isHidden = true
        table.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "cell"
        )
        
        return table
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        
        return spinner
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
        backgroundColor = .systemBackground
        
        addSubviews(tableView, spinner)
        spinner.startAnimating()

        addConstraints()
    }

}

// MARK: - PublicMethods
extension RMLocationView {
    public func configure(with viewModel: RMLocationViewViewModel) {
        self.viewModel = viewModel
    }
}


// MARK: - Constraints
private extension RMLocationView {
    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
