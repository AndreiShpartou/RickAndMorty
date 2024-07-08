//
//  RMEpisodeInfoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 10/06/2024.
//

import UIKit

final class RMEpisodeInfoCollectionViewCell: UICollectionViewCell {

    static let cellIdentifier = "RMEpisodeInfoCollectionViewCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.adjustsFontSizeToFitWidth = true

        return label
    }()

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .regular)
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

        titleLabel.text = nil
        valueLabel.text = nil
    }
}

// MARK: - Setup
extension RMEpisodeInfoCollectionViewCell {
    private func setupView() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubviews(titleLabel, valueLabel)

        setupLayer()

        addConstraints()
    }

    private func setupLayer() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.secondaryLabel.cgColor
    }
}

// MARK: - Public
extension RMEpisodeInfoCollectionViewCell {
    func configure(with viewModel: RMEpisodeInfoCollectionViewCellViewModelProtocol) {
        titleLabel.text = viewModel.title
        valueLabel.text = viewModel.value
    }
}

// MARK: - Constraints
extension RMEpisodeInfoCollectionViewCell {
    private func addConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.47),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),

            valueLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: -10),
            valueLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.47),
            valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }
}
