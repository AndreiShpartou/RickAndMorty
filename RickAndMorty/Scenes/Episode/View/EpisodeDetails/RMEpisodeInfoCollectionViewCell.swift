//
//  RMEpisodeInfoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 10/06/2024.
//

import UIKit

final class RMEpisodeInfoCollectionViewCell: UICollectionViewCell {

    static let cellIdentifier = "RMEpisodeInfoCollectionViewCell"

    private let titleLabel: UILabel = .createLabel(fontSize: 20, weight: .medium)
    private let valueLabel: UILabel = .createLabel(fontSize: 20, weight: .regular, numberOfLines: 0, textAlignment: .right)

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

        resetView()
    }
}

// MARK: - PublicMethods
extension RMEpisodeInfoCollectionViewCell {
    func configure(with viewModel: RMEpisodeInfoCollectionViewCellViewModelProtocol) {
        titleLabel.text = viewModel.title
        valueLabel.text = viewModel.value
    }
}

// MARK: - Setup
extension RMEpisodeInfoCollectionViewCell {
    private func setupView() {
        contentView.backgroundColor = .secondarySystemBackground
        setupLayer()

        contentView.addSubviews(titleLabel, valueLabel)

        addConstraints()
    }

    private func setupLayer() {
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.secondaryLabel.cgColor
    }

    private func resetView() {
        titleLabel.text = nil
        valueLabel.text = nil
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
