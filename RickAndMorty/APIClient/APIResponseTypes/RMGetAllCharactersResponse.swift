//
//  RMGetAllCharactersResponse.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 05/06/2024.
//

import Foundation

struct RMGetAllCharactersResponse: Codable, RMPagedResponseProtocol {
    let info: RMResponseInfo
    let results: [RMCharacter]
}
