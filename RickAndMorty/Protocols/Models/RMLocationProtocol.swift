//
//  RMLocationProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 11/07/2024.
//

import Foundation

protocol RMLocationProtocol: Codable {
    var id: Int { get }
    var name: String { get }
    var type: String { get }
    var dimension: String { get }
    var residents: [String] { get }
    var url: String { get }
    var created: String { get }
}
