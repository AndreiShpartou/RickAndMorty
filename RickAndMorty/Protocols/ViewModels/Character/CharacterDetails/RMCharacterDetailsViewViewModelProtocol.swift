//
//  RMCharacterDetailViewViewModelProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 06/07/2024.
//

import Foundation
import UIKit

protocol RMCharacterDetailsViewViewModelProtocol: AnyObject {
    var sections: [SectionType] { get }
    var title: String { get }
    var episodes: [String] { get }
    func getDataToShare() -> [Any]
}
