//
//  RMFooterLoadingCollectionReusableView.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 06/06/2024.
//

import UIKit

final class RMFooterLoadingCollectionReusableView: UICollectionReusableView {
    static let identifier = "RMFooterLoadingCollectionReusableView"
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetupView
    private func setupView() {
        backgroundColor = .systemBackground
        
        addSubviews(spinner)
        addConstraints()
    }
    
    public func startAnimating() {
        spinner.startAnimating()
    }
    
}

// MARK: - Constraints
private extension RMFooterLoadingCollectionReusableView {
    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
