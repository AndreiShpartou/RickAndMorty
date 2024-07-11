//
//  RMLocationView.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 12/06/2024.
//

import UIKit

// View that handles showing table of locations
// MARK: - View Implementation
final class RMLocationView: UIView {

    private let tableViewHandler: RMLocationTableViewHandler

    private lazy var spinner: UIActivityIndicatorView = createSpinner()
    private lazy var tableView: UITableView = createTableView()

    // MARK: - Init
    init(tableViewHandler: RMLocationTableViewHandler) {
        self.tableViewHandler = tableViewHandler
        super.init(frame: .zero)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - PublicMethods
extension RMLocationView: RMLocationViewProtocol {
    func setNilValueForScrollOffset() {
        tableView.setContentOffset(.zero, animated: true)
    }

    func didLoadInitialLocations() {
        spinner.stopAnimating()
        tableView.isHidden = false
        tableView.reloadData()
        UIView.animate(withDuration: 0.3) {
            self.tableView.alpha = 1
        }
    }

    func didLoadMoreLocations() {
        tableView.tableFooterView = nil
        tableView.reloadData()
    }

    func showLoadingIndicator() {
        let footerView = RMTableLoadingFooterView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        tableView.tableFooterView = footerView
    }
}

// MARK: - Setup
extension RMLocationView {
    private func setupView() {
        backgroundColor = .systemBackground

        addSubviews(tableView, spinner)
        setupSubViews()

        addConstraints()
    }

    private func setupSubViews() {
        spinner.startAnimating()
        setupTableView()
    }

    private func setupTableView() {
        tableView.delegate = tableViewHandler
        tableView.dataSource = tableViewHandler
    }
}

// MARK: - Helpers
extension RMLocationView {
    private func createSpinner() -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true

        return spinner
    }

    private func createTableView() -> UITableView {
        let table = UITableView(frame: .zero, style: .grouped)
        table.alpha = 0
        table.isHidden = true
        table.register(
            RMLocationTableViewCell.self,
            forCellReuseIdentifier: "RMLocationTableViewCell"
        )

        return table
    }
}

// MARK: - Constraints
extension RMLocationView {
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
