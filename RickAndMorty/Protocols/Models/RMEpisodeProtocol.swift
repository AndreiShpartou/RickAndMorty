//
//  RMEpisodeProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 07/07/2024.
//

import Foundation

// Protocol defining the interface for episode data
protocol RMEpisodeProtocol: RMEpisodeDataRenderProtocol {
    var id: Int { get }
    var characters: [String] { get }
    var url: String { get }
    var created: String { get }
}

// Protocol defining the interface for episode data rendering
protocol RMEpisodeDataRenderProtocol {
    var episode: String { get }
    var name: String { get }
    var air_date: String { get }
}
