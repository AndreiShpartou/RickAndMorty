//
//  RMCharacterPhotoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 08/06/2024.
//

import UIKit

final class RMCharacterPhotoCollectionViewCell: UICollectionViewCell {

    static let cellIdentifier = "RMCharacterPhotoCollectionViewCell"

    private lazy var imageView: UIImageView = .createImageView(contentMode: .scaleAspectFill, clipsToBounds: true, cornerRadius: 15)

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

        imageView.image = nil
    }
}

// MARK: - Public Methods
extension RMCharacterPhotoCollectionViewCell {
    func configure(with viewModel: RMCharacterPhotoCollectionViewCellViewModelProtocol) {
        viewModel.fetchImage { [weak self] result, _ in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(data: data)
                }
            case .failure(let error):
                NSLog("Failed to fetch character detail image: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Setup
extension RMCharacterPhotoCollectionViewCell {
    private func setupView() {
        contentView.addSubviews(imageView)
        addConstraints()
    }
}

// MARK: - Constraints
extension RMCharacterPhotoCollectionViewCell {
    private func addConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
