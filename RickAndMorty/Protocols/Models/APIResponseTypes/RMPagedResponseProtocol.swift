//
//  RMPagedResponseProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 14/07/2024.
//

import Foundation

protocol RMPagedResponseProtocol: Codable {
    associatedtype ResultType: Codable
    var info: RMResponseInfo { get }
    var results: [ResultType] { get }
}
