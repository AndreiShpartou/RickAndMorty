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
        characterListView.delegate = self
        view = characterListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    // MARK: - DeInit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup
    private func setup() {
        title = "Characters"
        addChangeThemeButton()
        addSearchButton()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(tabBarItemDoubleTapped),
            name: .tabBarItemDoubleTapped,
            object: nil
        )
    }
    
    private func addChangeThemeButton() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "lightbulb.fill"),
            style: .plain,
            target: self,
            action: #selector(didTapChangeTheme)
        )
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .search,
            target: self,
            action: #selector(didTapSearch)
        )
    }
    
    @objc
    private func tabBarItemDoubleTapped(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let viewController = userInfo["viewController"] as? UIViewController else {
            return
        }
        
        if viewController == self {
            characterListView.setNilValueForScrollOffset()
        }
    }
    
    // MARK: - ActionMethods
    @objc
    private func didTapChangeTheme() {
        
    }
    
    @objc
    private func didTapSearch() {
        let viewController = RMSearchViewController(config: .init(type: .character))
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(viewController, animated: true)
    }

}


// MARK: - RMCharacterListViewDelegate
extension RMCharacterViewController: RMCharacterListViewDelegate {
    func rmCharacterListView(_ characterListView: RMCharacterListView, didSelectCharacter character: RMCharacter) {
        // Open detail controller for that character
        let viewModel = RMCharacterDetailViewViewModel(character: character)
        let detailVC = RMCharacterDetailsViewController(viewModel: viewModel)
        detailVC.navigationItem.largeTitleDisplayMode = .never
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
