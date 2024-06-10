//
//  RMSearchViewController.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 09/06/2024.
//

import UIKit

/// Configurable controller to search
final class RMSearchViewController: UIViewController {

    struct Config {
        enum ConfigType {
            case character
            case episode
            case location
        }
        
        let type: ConfigType
    }
    
    private let config: Config
    
    // MARK: - Init
    init(config: Config) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Search"
        view.backgroundColor = .systemBackground
    }

}
