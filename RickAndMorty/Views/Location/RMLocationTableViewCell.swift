//
//  RMLocationTableViewCell.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 12/06/2024.
//

import UIKit

// Single cell for a location
class RMLocationTableViewCell: UITableViewCell {

    static let cellIdentifier = "RMLocationTableViewCell"

    private let nameLabel: UILabel = .createLabel(fontSize: 20, weight: .medium)
    private let typeLabel: UILabel = .createLabel(fontSize: 15, weight: .regular, textColor: .secondaryLabel)
    private let dimensionLabel: UILabel = .createLabel(fontSize: 15, weight: .light, textColor: .secondaryLabel)

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()

        resetLabels()
    }
}

// MARK: - PublicMethods
extension RMLocationTableViewCell {
    func configure(with viewModel: RMLocationTableViewCellViewModelWrapper) {
        nameLabel.text = viewModel.name
        typeLabel.text = viewModel.type
        dimensionLabel.text = viewModel.dimension
    }
}

// MARK: - Setup
extension RMLocationTableViewCell {
    private func setupView() {
        contentView.addSubviews(nameLabel, typeLabel, dimensionLabel)
        accessoryType = .disclosureIndicator

        addConstraints()
    }

    private func resetLabels() {
        nameLabel.text = nil
        typeLabel.text = nil
        dimensionLabel.text = nil
    }
}

// MARK: - Constraints
extension RMLocationTableViewCell {
    func addConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),

            typeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            typeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            typeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),

            dimensionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            dimensionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            dimensionLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 10),
            dimensionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        nameLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        typeLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        dimensionLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}
