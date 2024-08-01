//
//  RMCharacter.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 03/06/2024.
//

import Foundation

struct RMCharacter: RMCharacterProtocol {
    let id: Int
    let name: String
    let status: RMCharacterStatus
    let species: String
    let type: String
    let gender: RMCharacterGender
    let origin: RMOriginLocation
    let location: RMLastLocation
    let image: String
    let episode: [String]
    let url: String
    let created: String
}
