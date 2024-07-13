//
//  RMGetAllEpisodesResponseProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 13/07/2024.
//

import Foundation

protocol RMGetAllEpisodesResponseProtocol: Codable {
    var info: RMGetResponseInfoProtocol { get }
    var results: [RMEpisodeProtocol] { get }
}
