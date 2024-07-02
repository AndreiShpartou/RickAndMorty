//
//  RMLocationView.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 12/06/2024.
//

import UIKit

protocol RMLocationViewDelegate: AnyObject {
    func rmLocationView(_ locationView: RMLocationView, didSelect location: RMLocation)
}

final class RMLocationView: UIView {
    // MARK: - Properties
    weak var delegate: RMLocationViewDelegate?

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
        let table = UITableView(frame: .zero, style: .grouped)
        table.alpha = 0
        table.isHidden = true
        table.register(
            RMLocationTableViewCell.self,
            forCellReuseIdentifier: "RMLocationTableViewCell"
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

        configureTable()
        addConstraints()
    }

    private func configureTable() {
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - PublicMethods
extension RMLocationView {
    func configure(with viewModel: RMLocationViewViewModel) {
        self.viewModel = viewModel
        self.viewModel?.registerDidLoadMoreLocation { [weak self] in
            self?.tableView.tableFooterView = nil
            self?.tableView.reloadData()
        }
    }

    func setNilValueForScrollOffset() {
        tableView.setContentOffset(.zero, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension RMLocationView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.cellViewModels.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellViewModels = viewModel?.cellViewModels else {
            fatalError("Unable to define ViewModel")
        }

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "RMLocationTableViewCell",
            for: indexPath
        ) as? RMLocationTableViewCell else {
            fatalError("Unable to define cell for location")
        }

        let cellViewModel = cellViewModels[indexPath.row]
        cell.configure(with: cellViewModel)

        return cell
    }
}

// MARK: - UITableViewDelegate
extension RMLocationView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let locationModel = viewModel?.location(at: indexPath.row) else {
            return
        }

        delegate?.rmLocationView(
            self,
            didSelect: locationModel
        )
    }
}

// MARK: - UIScrollViewDelegate
extension RMLocationView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let viewModel = viewModel,
              viewModel.shouldShowLoadMoreIndicator,
              !viewModel.isLoadingMoreLocations,
              !viewModel.cellViewModels.isEmpty
        else {
            return
        }

        let offset = scrollView.contentOffset.y
        let totalContentHeight = scrollView.contentSize.height
        let totalScrollViewFixedHeight = scrollView.frame.size.height

        if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
            showLoadingIndicator()
            viewModel.fetchAdditionalLocationsWithDelay(0.1)
        }
    }

    private func showLoadingIndicator() {
        let footerView = RMTableLoadingFooterView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        tableView.tableFooterView = footerView
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
