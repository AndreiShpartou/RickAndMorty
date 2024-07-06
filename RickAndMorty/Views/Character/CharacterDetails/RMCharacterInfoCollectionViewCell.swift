//
//  RMCharacterInfoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 08/06/2024.
//

import UIKit

final class RMCharacterInfoCollectionViewCell: UICollectionViewCell {

    static let cellIdentifier = "RMCharacterInfoCollectionViewCell"

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .light)
        label.adjustsFontSizeToFitWidth = true

        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .medium)

        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private let iconImageView: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit

        return icon
    }()

    private let titleContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .quaternarySystemFill

        return view
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

        valueLabel.text = nil
        titleLabel.text = nil
        iconImageView.image = nil
        iconImageView.tintColor = .label
        titleLabel.textColor = .label
    }
}

// MARK: - Setup
extension RMCharacterInfoCollectionViewCell {
    private func setupView() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.addSubviews(valueLabel, iconImageView, titleContainerView)

        titleContainerView.addSubviews(titleLabel)

        addConstraints()
    }
}

// MARK: - Public Methods
extension RMCharacterInfoCollectionViewCell {
    func configure(with viewModel: RMCharacterInfoCollectionViewCellViewModelProtocol) {
        titleLabel.text = viewModel.title
        valueLabel.text = viewModel.displayValue
        iconImageView.image = viewModel.iconImage
        iconImageView.tintColor = viewModel.tintColor
        titleLabel.textColor = viewModel.tintColor
    }
}

// MARK: - Constraints
extension RMCharacterInfoCollectionViewCell {
    private func addConstraints() {
        NSLayoutConstraint.activate([
            titleContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleContainerView.heightAnchor.constraint(
                equalTo: contentView.heightAnchor,
                multiplier: 0.33
            ),

            titleLabel.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: titleContainerView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: titleContainerView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: titleContainerView.bottomAnchor),

            iconImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 20
            ),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 35
            ),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),

            valueLabel.leadingAnchor.constraint(
                equalTo: iconImageView.trailingAnchor,
                constant: 10
            ),
            valueLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -10
            ),
            valueLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor
            ),
            valueLabel.bottomAnchor.constraint(
                equalTo: titleContainerView.topAnchor
            )
        ])
    }
}
