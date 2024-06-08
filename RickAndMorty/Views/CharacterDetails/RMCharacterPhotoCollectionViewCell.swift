//
//  RMCharacterPhotoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 08/06/2024.
//

import UIKit

final class RMCharacterPhotoCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "RMCharacterPhotoCollectionViewCell"
    
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
extension RMCharacterPhotoCollectionViewCell {
    public func configure(with: RMCharacterPhotoCollectionViewCellViewModel) {
        
    }
}

// MARK: - Constraints
private extension RMCharacterPhotoCollectionViewCell {
    private func addConstraints() {
        
    }
}
