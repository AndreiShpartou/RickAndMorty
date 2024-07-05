//
//  RMEpisode.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 03/06/2024.
//

import Foundation

protocol RMEpisodeDataRender {
    var episode: String { get }
    var name: String { get }
    var air_date: String { get }
}

struct RMEpisode: Codable, RMEpisodeDataRender {
    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
}
