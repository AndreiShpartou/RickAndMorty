//
//  RMCharacterDetailViewViewModelProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 06/07/2024.
//

import Foundation
import UIKit

protocol RMCharacterDetailViewViewModelProtocol {
    var sections: [RMCharacterDetailViewViewModel.SectionType] { get }
    var title: String { get }
    var episodes: [String] { get }
    func getDataToShare() -> [Any]
    func createPhotoSectionLayout() -> NSCollectionLayoutSection
    func createInfoSectionLayout() -> NSCollectionLayoutSection
    func createEpisodeSectionLayout() -> NSCollectionLayoutSection
}
