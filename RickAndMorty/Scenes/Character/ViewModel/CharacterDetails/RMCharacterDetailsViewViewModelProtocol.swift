//
//  RMCharacterDetailViewViewModelProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 06/07/2024.
//

import Foundation
import UIKit

protocol RMCharacterDetailsViewViewModelProtocol: AnyObject {
    var delegate: RMCharacterDetailsViewViewModelDelegate? { get set }
    var sections: [RMSectionType] { get }
    var title: String { get }

    func fetchCharacterData()
    func getEpisode(at index: Int) -> RMEpisodeProtocol?
    func getDataToShare() -> [Any]
}

protocol RMCharacterDetailsViewViewModelDelegate: AnyObject {
    func didFetchCharacterDetails()
}
