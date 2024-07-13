//
//  RMGetAllCharactersResponseProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 13/07/2024.
//

import Foundation

protocol RMGetAllCharactersResponseProtocol: Codable {
    var info: RMGetResponseInfoProtocol { get }
    var results: [RMCharacterProtocol] { get }
}
