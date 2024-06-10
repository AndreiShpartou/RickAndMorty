//
//  RMEpisodeInfoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 10/06/2024.
//

import UIKit

final class RMEpisodeInfoCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "RMEpisodeInfoCollectionViewCell"
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - SetupView
    private func setupView() {
        contentView.backgroundColor = .secondarySystemBackground
    }
    
    private func setupLayer() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.secondaryLabel.cgColor
    }

}

// MARK: - Configure
extension RMEpisodeInfoCollectionViewCell {
    public func configure(with viewModel: RMEpisodeInfoCollectionViewCellViewModel) {
        
    }
}
