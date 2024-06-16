//
//  RMTableLoadingFooterView.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 16/06/2024.
//

import UIKit

class RMTableLoadingFooterView: UIView {

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
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
        addSubviews(spinner)
        spinner.startAnimating()
        addConstraints()
    }
    
}

// MARK: - Constraints
private extension RMTableLoadingFooterView {
    func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            spinner.widthAnchor.constraint(equalToConstant: 55),
            spinner.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
}
