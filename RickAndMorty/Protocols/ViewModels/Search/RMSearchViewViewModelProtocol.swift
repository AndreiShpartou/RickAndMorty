//
//  RMSearchViewViewModelProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 13/07/2024.
//

import Foundation

protocol RMSearchViewViewModelProtocol {
    var configType: RMConfigType { get }

    func set(value: String, for option: RMDynamicOption)
    func set(query text: String)
    func registerOptionChangeBlock(_ block: @escaping ((RMDynamicOption, String)) -> Void)
    func registerSearchResultHandler(_ block: @escaping (RMSearchResultsViewViewModelProtocol) -> Void)
    func registerNoResultsHandler(_ block: @escaping () -> Void)
    func registerProcessSearchHandler(_ block: @escaping () -> Void)
    func executeSearch()
    func locationSearchResult(at index: Int) -> RMLocationProtocol?
    func characterSearchResult(at index: Int) -> RMCharacterProtocol?
    func episodeSearchResult(at index: Int) -> RMEpisodeProtocol?
}
