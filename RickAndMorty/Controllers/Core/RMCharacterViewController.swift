//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 03/06/2024.
//

import UIKit

/// Controller to show and search for Characters
final class RMCharacterViewController: UIViewController {

    private let characterListView = RMCharacterListView()

    // MARK: - LifeCycle
    override func loadView() {
        view = characterListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetupView()
    }
    // MARK: - SetupView
    private func SetupView() {
        view.backgroundColor = .systemBackground
        title = "Characters"
    }
}
