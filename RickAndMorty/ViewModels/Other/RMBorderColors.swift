//
//  RMBorderColors.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 15/07/2024.
//

import UIKit

enum RMBorderColors {
    static let color: [UIColor] = [
        .systemCyan,
        .systemRed,
        .systemBlue,
        .systemPink,
        .systemTeal,
        .systemYellow,
        .systemBrown,
        .systemMint,
        .systemIndigo
    ]

    static func randomColor() -> UIColor {
        return color.randomElement() ?? UIColor.blue
    }
}
