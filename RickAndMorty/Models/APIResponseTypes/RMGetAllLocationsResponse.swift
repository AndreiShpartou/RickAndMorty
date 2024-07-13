//
//  RMGetLocationsResponse.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 05/06/2024.
//

import Foundation

struct RMGetAllLocationsResponse: Codable {
    let info: RMResponseInfo
    let results: [RMLocation]
}
