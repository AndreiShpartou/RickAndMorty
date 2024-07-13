//
//  RMGetResponseInfoProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 13/07/2024.
//

import Foundation

protocol RMGetResponseInfoProtocol: Codable {
    var count: Int { get }
    var pages: Int { get }
    var next: String? { get }
    var prev: String? { get }
}
