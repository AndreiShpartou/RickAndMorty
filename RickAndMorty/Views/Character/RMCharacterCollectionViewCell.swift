//
//  RMCharacterCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 05/06/2024.
//

import UIKit

/// Single cell for a character
final class RMCharacterCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "RMCharacterCollectionViewCell"
    
    // MARK: - Subview Properties
    private let commonView = UIView(frame: .zero)
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(
            ofSize: 18,
            weight: .medium
        )
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(
            ofSize: 16,
            weight: .regular
        )
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
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
        imageView.image = nil
        nameLabel.text = nil
        statusLabel.text = nil
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupLayer()
    }
    
    // MARK: - Setup ContentView
    private func setupContentView() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubviews(commonView)
        commonView.addSubviews(imageView, nameLabel, statusLabel)
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
}

// MARK: - PublicMethods
extension RMCharacterCollectionViewCell {
    public func configure(with viewModel: RMCharacterCollectionViewCellViewModel) {
        nameLabel.text = viewModel.characterName
        statusLabel.text = viewModel.characterStatusText
        viewModel.fetchImage { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self?.imageView.image = image
                }
            case .failure:
                break
            }
            
        }
    }
}

// MARK: - Constraints
private extension RMCharacterCollectionViewCell {
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
            imageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -3)
        ])
    }
}
