//
//  RMGetAllEpisodesResponse.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 05/06/2024.
//

import Foundation

struct RMGetAllEpisodesResponse: Codable, RMPagedResponseProtocol {
    let info: RMResponseInfo
    let results: [RMEpisode]
}
