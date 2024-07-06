//
//  RMCharacterInfoCollectionViewCellViewModelProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 06/07/2024.
//

import UIKit

protocol RMCharacterInfoCollectionViewCellViewModelProtocol: AnyObject {
    var title: String { get }
    var displayValue: String { get }
    var iconImage: UIImage? { get }
    var tintColor: UIColor { get }
}
