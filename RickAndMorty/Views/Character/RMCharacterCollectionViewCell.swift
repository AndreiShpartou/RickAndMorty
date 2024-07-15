//
//  RMCharacterCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 05/06/2024.
//

import UIKit

// Single cell for a character
final class RMCharacterCollectionViewCell: UICollectionViewCell {

    static let cellIdentifier = "RMCharacterCollectionViewCell"

    private let commonView = UIView()
    private let imageView: UIImageView = .createImageView(contentMode: .scaleAspectFill, clipsToBounds: true)
    private let spinner: UIActivityIndicatorView = .createSpinner()
    private let nameLabel: UILabel = .createLabel(fontSize: 18, weight: .medium, textColor: .label)
    private let statusLabel: UILabel = .createLabel(fontSize: 16, weight: .regular, textColor: .secondaryLabel)
    private var characterImageUrl: URL?

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

        resetView()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        setupLayer()
    }
}

// MARK: - PublicMethods
extension RMCharacterCollectionViewCell {
    func configure(with viewModel: RMCharacterCollectionViewCellViewModelWrapper) {
        nameLabel.text = viewModel.characterName
        statusLabel.text = viewModel.characterStatusText
        characterImageUrl = viewModel.characterImageUrl

        spinner.startAnimating()
        viewModel.fetchImage { [weak self] result, url in
            switch result {
            case .success(let data):
                guard let currentURL = self?.characterImageUrl,
                      let responseURL = url,
                      currentURL == responseURL else {
                    return
                }

                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(data: data)
                    self?.spinner.stopAnimating()
                }
            case .failure(let error):
                NSLog("Failed to fetch character image: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Setup
extension RMCharacterCollectionViewCell {
    private func setupContentView() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubviews(commonView)

        commonView.addSubviews(imageView, nameLabel, statusLabel, spinner)

        setupLayer()
        addConstraints()
    }

    private func setupLayer() {
        commonView.layer.masksToBounds = true
        commonView.layer.cornerRadius = 10

        contentView.layer.shadowPath = UIBezierPath(rect: contentView.bounds).cgPath
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowColor = UIColor.label.cgColor
        contentView.layer.shadowOffset = CGSize(width: -5, height: 5)
        contentView.layer.shadowOpacity = 0.3
    }

    private func resetView() {
        imageView.image = nil
        nameLabel.text = nil
        statusLabel.text = nil
    }
}

// MARK: - Constraints
extension RMCharacterCollectionViewCell {
    private func addConstraints() {
        NSLayoutConstraint.activate([
            commonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            commonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            commonView.topAnchor.constraint(equalTo: contentView.topAnchor),
            commonView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            statusLabel.leadingAnchor.constraint(equalTo: commonView.leadingAnchor, constant: 7),
            statusLabel.trailingAnchor.constraint(equalTo: commonView.trailingAnchor, constant: -7),
            statusLabel.bottomAnchor.constraint(equalTo: commonView.bottomAnchor, constant: -3),
            statusLabel.heightAnchor.constraint(equalToConstant: 30),

            nameLabel.leadingAnchor.constraint(equalTo: commonView.leadingAnchor, constant: 7),
            nameLabel.trailingAnchor.constraint(equalTo: commonView.trailingAnchor, constant: -7),
            nameLabel.bottomAnchor.constraint(equalTo: statusLabel.topAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 30),

            imageView.leadingAnchor.constraint(equalTo: commonView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: commonView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: commonView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -3),

            spinner.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            spinner.widthAnchor.constraint(equalToConstant: 50),
            spinner.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
