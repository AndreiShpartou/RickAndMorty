//
//  RMGetAllLocationsResponseProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 13/07/2024.
//

import Foundation

protocol RMGetAllLocationsResponseProtocol: Codable {
    var info: RMGetResponseInfoProtocol { get }
    var results: [RMLocationProtocol] { get }
}
