//
//  RMEpisodeDetailsViewViewModelProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 08/07/2024.
//

import Foundation

protocol RMEpisodeDetailsViewViewModelProtocol: AnyObject {
    var delegate: RMEpisodeDetailsViewViewModelDelegate? { get set }
    var sections: [RMSectionType] { get }

    func fetchEpisodeData()
    func character(at index: Int) -> RMCharacterProtocol?
    func getDataToShare() -> [Any]
}

protocol RMEpisodeDetailsViewViewModelDelegate: AnyObject {
    func didFetchEpisodeDetails()
}
