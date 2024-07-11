//
//  RMCharacterProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 07/07/2024.
//

import Foundation

// Protocol defining the interface for character data
protocol RMCharacterProtocol: Codable {
    var id: Int { get }
    var name: String { get }
    var status: RMCharacterStatus { get }
    var species: String { get }
    var type: String { get }
    var gender: RMCharacterGender { get }
    var origin: RMOriginLocation { get }
    var location: RMLastLocation { get }
    var image: String { get }
    var episode: [String] { get }
    var url: String { get }
    var created: String { get }
}
