//
//  RMThemeManager.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 28/06/2024.
//

import UIKit

protocol RMThemeStorageProtocol {
    var currentTheme: UIUserInterfaceStyle { get set }
}

class RMThemeStorage: RMThemeStorageProtocol {

    private let themeKey = "SelectedTheme"

    var currentTheme: UIUserInterfaceStyle {
        get {
            guard let storedTheme = UserDefaults.standard.value(forKey: themeKey) as? Int,
                  let theme = UIUserInterfaceStyle(rawValue: storedTheme) else {
                return .dark
            }

            return theme
        }

        set {
            UserDefaults.standard.setValue(newValue.rawValue, forKey: themeKey)
        }
    }
}

// Manage dark / light mode
class RMThemeManager {
    // Shared singleton instance
    static let shared = RMThemeManager()

    private var themeStorage: RMThemeStorageProtocol = RMThemeStorage()

    // MARK: - Init
    private init() {}

    // MARK: - PublicMethods
    func applyCurrentTheme() {
        applyTheme(themeStorage.currentTheme)
    }

    func toggleTheme() {
        let newTheme: UIUserInterfaceStyle = (themeStorage.currentTheme == .dark) ? .light : .dark
        themeStorage.currentTheme = newTheme
        applyTheme(newTheme)
    }

    // MARK: - PrivateMethods
    private func applyTheme(_ theme: UIUserInterfaceStyle) {
        let windows = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }

        windows.forEach { window in
            window.overrideUserInterfaceStyle = theme
        }
    }
}
