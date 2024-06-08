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
    }
        
    // MARK: - SetupView
    private func setupView() {
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.layer.cornerRadius = 8
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
        
    }
}
