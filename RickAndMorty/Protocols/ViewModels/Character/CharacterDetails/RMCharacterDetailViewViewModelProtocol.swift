//
//  RMCharacterDetailViewViewModelProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 06/07/2024.
//

import Foundation
import UIKit

protocol RMCharacterDetailViewViewModelProtocol: AnyObject {
    var delegate: RMCharacterDetailViewViewModelDelegate? { get set }
    var sections: [SectionType] { get }
    var title: String { get }
    var episodes: [String] { get }
    func getDataToShare() -> [Any]
    func createPhotoSectionLayout() -> NSCollectionLayoutSection
    func createInfoSectionLayout() -> NSCollectionLayoutSection
    func createEpisodeSectionLayout() -> NSCollectionLayoutSection
}

protocol RMCharacterDetailViewViewModelDelegate: AnyObject {
    func didSelectEpisode(_ episodeStringURL: String)
}
