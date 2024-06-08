//
//  RMCharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 06/06/2024.
//

import UIKit

class RMCharacterDetailViewController: UIViewController {
    
    private let viewModel: RMCharacterDetailViewViewModel
    private let detailView: RMCharacterDetailView

    // MARK: - Init
    init(viewModel: RMCharacterDetailViewViewModel) {
        self.viewModel = viewModel
        self.detailView = RMCharacterDetailView(
            frame: .zero,
            viewModel: viewModel
        )
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        detailView.collectionView.delegate = self
        detailView.collectionView.dataSource = self

        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        title = viewModel.title
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShare)
        )
    }
}

// MARK: - Actions
extension RMCharacterDetailViewController {
    
    @objc
    private func didTapShare() {
        // Share character info
    }
}

// MARK: - UICollectionViewDataSource
extension RMCharacterDetailViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 8
        case 2:
            return 20
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath
        )
        cell.backgroundColor = .systemTeal
        
        if indexPath.section == 0 {
            cell.backgroundColor = .systemTeal
        } else if indexPath.section == 1 {
            cell.backgroundColor = .systemCyan
        } else if indexPath.section == 2 {
            cell.backgroundColor = .systemMint
        }
        
        return cell
    }
    
    
}

// MARK: - UICollectionViewDelegate
extension RMCharacterDetailViewController: UICollectionViewDelegate {
    
}


