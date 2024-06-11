//
//  RMSettingsViewController.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 03/06/2024.
//

import SwiftUI
import UIKit
import SafariServices
import StoreKit

/// Controller to show various app options and settings
final class RMSettingsViewController: UIViewController {
    
    private var settingsSwiftUIController: UIHostingController<RMSettingsView>?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Settings"
        
        addSwiftUIController()
    }
    
    private func addSwiftUIController() {
        let settingsSwiftUIController = UIHostingController(
            rootView: RMSettingsView(
                viewModel: RMSettingsViewViewModel(
                    cellViewModels: RMSettingsOption.allCases.compactMap({
                        return RMSettingsCellViewViewModel(type: $0) { [weak self] option in
                            self?.handleTap(option: option)
                        }
                    })
                )
            )
        )
        
        addChild(settingsSwiftUIController)
        settingsSwiftUIController.didMove(toParent: self)
        
        view.addSubview(settingsSwiftUIController.view)
        settingsSwiftUIController.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.settingsSwiftUIController = settingsSwiftUIController
        
        NSLayoutConstraint.activate([
            settingsSwiftUIController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            settingsSwiftUIController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            settingsSwiftUIController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsSwiftUIController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func handleTap(option: RMSettingsOption) {
        guard Thread.current.isMainThread else {
            return
        }
        
        if let url = option.targetUrl {
            // Open website
            let viewController = SFSafariViewController(url: url)
            present(viewController, animated: true)
        } else if option == .rateApp {
            // Show rating prompt
            if let windowScene = self.view.window?.windowScene {
                SKStoreReviewController.requestReview(in: windowScene)
            }
        }
    }
}


