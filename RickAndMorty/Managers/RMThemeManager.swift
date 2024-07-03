//
//  RMThemeManager.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 28/06/2024.
//

import UIKit

// Manage dark / light mode
class RMThemeManager {
    // Shared singleton instance
    static let shared = RMThemeManager()
    
    private let themeKey = "SelectedTheme"
    
    private var currentTheme: UIUserInterfaceStyle {
        get {
            guard let storedTheme = UserDefaults.standard.value(forKey: themeKey) as? Int,
                  let theme = UIUserInterfaceStyle(rawValue: storedTheme) else {
                return .dark
            }
            
            return theme
        }
        
        set {
            UserDefaults.standard.setValue(newValue.rawValue, forKey: themeKey)
            applyTheme(newValue)
        }
    }
    
    // MARK: - Init
    private init() {}
    
    
    // MARK: - PublicMethods
    func applyCurrentTheme() {
        applyTheme(currentTheme)
    }
    
    func toggleTheme() {
        currentTheme = (currentTheme == .dark) ? .light : .dark
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
