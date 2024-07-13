//
//  RMVersatileResponse.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 13/07/2024.
//

import Foundation

// protocol for handy using generics into RMSearchResultsViewViewModel
protocol RMVersatileResponse: Codable {
    var info: RMGetResponseInfoProtocol { get }
    var results: [RMLocationProtocol & RMEpisodeProtocol & RMCharacterProtocol] { get }
}
