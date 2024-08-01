//
//  RMSearchInputViewViewModelProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 12/07/2024.
//

import Foundation

protocol RMSearchInputViewViewModelProtocol: AnyObject {
    var hasDynamicOptions: Bool { get }
    var options: [RMDynamicOption] { get }
    var searchPlaceHolderText: String { get }
}
