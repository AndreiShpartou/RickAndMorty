//
//  RMEpisodeCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 08/06/2024.
//

import UIKit

// Single cell for an episode
final class RMEpisodeCollectionViewCell: UICollectionViewCell {

    static let cellIdentifier = "RMEpisodeCollectionViewCell"

    private let seasonLabel: UILabel = .createLabel(fontSize: 20, weight: .semibold)
    private let nameLabel: UILabel = .createLabel(fontSize: 22, weight: .regular, numberOfLines: 0)
    private let airDateLabel: UILabel = .createLabel(fontSize: 18, weight: .light)

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupContentView()
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

// MARK: - Public Methods
extension RMEpisodeCollectionViewCell {
    func configure(with viewModel: RMEpisodeCollectionViewCellViewModelWrapper) {
        viewModel.registerForData { [weak self] data in
            self?.seasonLabel.text = "Episode \(data.episode)"
            self?.nameLabel.text = data.name
            self?.airDateLabel.text = "Aired on \(data.air_date)"
        }
        viewModel.fetchEpisode()
        contentView.layer.borderColor = viewModel.borderColor.cgColor
    }
}

// MARK: - Setup
extension RMEpisodeCollectionViewCell {
    private func setupContentView() {
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.addSubviews(seasonLabel, nameLabel, airDateLabel)

        setupLayer()
        addConstraints()
    }

    private func setupLayer() {
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 2
    }

    private func resetLabels() {
        seasonLabel.text = nil
        nameLabel.text = nil
        airDateLabel.text = nil
    }
}

// MARK: - Constraints
extension RMEpisodeCollectionViewCell {
    private func addConstraints() {
        NSLayoutConstraint.activate([
            seasonLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 10
            ),
            seasonLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -10
            ),
            seasonLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 5
            ),
            seasonLabel.heightAnchor.constraint(
                equalTo: contentView.heightAnchor,
                multiplier: 0.3
            ),

            nameLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 10
            ),
            nameLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -10
            ),
            nameLabel.topAnchor.constraint(equalTo: seasonLabel.bottomAnchor),
            nameLabel.heightAnchor.constraint(
                equalTo: contentView.heightAnchor,
                multiplier: 0.3
            ),

            airDateLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 10
            ),
            airDateLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -10
            ),
            airDateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            airDateLabel.heightAnchor.constraint(
                equalTo: contentView.heightAnchor,
                multiplier: 0.3
            )
        ])
    }
}
