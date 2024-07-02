//
//  RMEpisode.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 03/06/2024.
//

import Foundation

struct RMEpisode: Codable, RMEpisodeDataRender {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
}
