//
//  RMResponseInfo.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 13/07/2024.
//

import Foundation

struct RMResponseInfo: Codable {
    var count: Int
    var pages: Int
    var next: String?
    var prev: String?
}
