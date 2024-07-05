//
//  RMServiceProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 05/07/2024.
//

import Foundation

protocol RMServiceProtocol {
    func execute<T: Codable>(
        _ request: RMRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    )
}
