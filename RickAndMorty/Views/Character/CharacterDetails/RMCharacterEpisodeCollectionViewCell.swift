//
//  RMCharacterEpisodeCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 08/06/2024.
//

import UIKit

final class RMCharacterEpisodeCollectionViewCell: UICollectionViewCell {

    static let cellIdentifier = "RMCharacterEpisodeCollectionViewCell"

    private let seasonLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.adjustsFontSizeToFitWidth = true

        return label
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true

        return label
    }()

    private let airDateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.adjustsFontSizeToFitWidth = true

        return label
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()

        nameLabel.text = nil
        airDateLabel.text = nil
        seasonLabel.text = nil
    }
}

// MARK: - Setup
extension RMCharacterEpisodeCollectionViewCell {
    private func setupView() {
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.addSubviews(seasonLabel, nameLabel, airDateLabel)

        setupLayer()
        addConstraints()
    }

    private func setupLayer() {
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 2
    }
}

// MARK: - Public Methods
extension RMCharacterEpisodeCollectionViewCell {
    func configure(with viewModel: any RMCharacterEpisodeCollectionViewCellViewModelProtocol) {
        viewModel.registerForData { [weak self] data in
            self?.seasonLabel.text = "Episode " + data.episode
            self?.nameLabel.text = data.name
            self?.airDateLabel.text = "Aired on " + data.air_date
        }
        viewModel.fetchEpisode()
        contentView.layer.borderColor = viewModel.borderColor.cgColor
    }
}

// MARK: - Constraints
extension RMCharacterEpisodeCollectionViewCell {
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
