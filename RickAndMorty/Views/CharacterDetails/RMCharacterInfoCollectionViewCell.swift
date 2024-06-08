//
//  RMCharacterInfoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 08/06/2024.
//

import UIKit

final class RMCharacterInfoCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "RMCharacterInfoCollectionViewCell"
    
    // MARK: - View Properties
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.text = "Earth"
        label.font = .systemFont(ofSize: 22, weight: .light)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Location"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        icon.image = UIImage(systemName: "globe")
        return icon
    }()
    
    private let titleContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
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
        
//        valueLabel.text = nil
//        titleLabel.text = nil
//        iconImageView.image = nil
    }
        
    // MARK: - SetupView
    private func setupView() {
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        contentView.addSubviews(valueLabel, iconImageView, titleContainerView)
        titleContainerView.addSubviews(titleLabel)
        addConstraints()
    }

}

// MARK: - Public Methods
extension RMCharacterInfoCollectionViewCell {
    public func configure(with: RMCharacterInfoCollectionViewCellViewModel) {
        
    }
}

// MARK: - Constraints
private extension RMCharacterInfoCollectionViewCell {
    private func addConstraints() {
        NSLayoutConstraint.activate([
            titleContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleContainerView.heightAnchor.constraint(
                equalTo: contentView.heightAnchor,
                multiplier: 0.33
            ),
            titleContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: titleContainerView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: titleContainerView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: titleContainerView.trailingAnchor),
            
            iconImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 35
            ),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            iconImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 20
            ),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            
            
            valueLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 35
            ),
            valueLabel.heightAnchor.constraint(equalToConstant: 30),
            valueLabel.leadingAnchor.constraint(
                equalTo: iconImageView.trailingAnchor,
                constant: 10
            ),
            valueLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -10
            )
        ])
    }
}
