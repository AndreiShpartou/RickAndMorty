//
//  RMCharacterEpisodeCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 08/06/2024.
//

import UIKit

final class RMCharacterEpisodeCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "RMCharacterEpisodeCollectionViewCell"
    
    // MARK: - View Properties
    private let seasonLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .regular)
        return label
    }()
    
    private let airDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
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
        
    // MARK: - SetupView
    private func setupView() {
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.systemBlue.cgColor
        
        addSubviews(seasonLabel, nameLabel, airDateLabel)
        addConstraints()
    }

}

// MARK: - Public Methods
extension RMCharacterEpisodeCollectionViewCell {
    public func configure(with viewModel: RMCharacterEpisodeCollectionViewCellViewModel) {
        viewModel.registerForData { [weak self] data in
            self?.nameLabel.text = data.name
            self?.airDateLabel.text = "Episode " + data.air_date
            self?.seasonLabel.text = "Aired on " + data.episode
        }
        viewModel.fetchEpisode()
    }
}

// MARK: - Constraints
private extension RMCharacterEpisodeCollectionViewCell {
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
