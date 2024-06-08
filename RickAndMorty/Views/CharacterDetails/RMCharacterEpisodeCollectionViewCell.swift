//
//  RMCharacterEpisodeCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 08/06/2024.
//

import UIKit

final class RMCharacterEpisodeCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "RMCharacterEpisodeCollectionViewCell"
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        addConstraints()
    }

}

// MARK: - Public Methods
extension RMCharacterEpisodeCollectionViewCell {
    public func configure(with: RMCharacterEpisodeCollectionViewCellViewModel) {
        
    }
}

// MARK: - Constraints
private extension RMCharacterEpisodeCollectionViewCell {
    private func addConstraints() {
        
    }
}
