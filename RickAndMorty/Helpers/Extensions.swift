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
    static let didChangeTheme = Notification.Name("didChangeTheme")
}

extension UILabel {
    static func createLabel(
        fontSize: CGFloat,
        weight: UIFont.Weight,
        numberOfLines: Int = 1,
        textAlignment: NSTextAlignment = .left,
        textColor: UIColor? = nil
    ) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: fontSize, weight: weight)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = numberOfLines
        label.textAlignment = textAlignment
        if let textColor = textColor {
            label.textColor = textColor
        }

        return label
    }
}

extension UIImageView {
    static func createImageView(contentMode: UIView.ContentMode, clipsToBounds: Bool = false, cornerRadius: CGFloat = 0) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = clipsToBounds
        imageView.layer.cornerRadius = cornerRadius

        return imageView
    }
}

extension UIActivityIndicatorView {
    static func createSpinner() -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true

        return spinner
    }
}
