//
//  Extensions.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 05/06/2024.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}

extension UIDevice {
    static let isPhone = UIDevice.current.userInterfaceIdiom == .phone
    static var isLandscape: Bool {
        UIDevice.current.orientation.isLandscape
    }
}

extension Notification.Name {
    static let tabBarItemDoubleTapped = Notification.Name("tabBarItemDoubleTapped")
}
