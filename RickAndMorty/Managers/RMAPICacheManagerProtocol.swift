//
//  RMAPICacheManagerProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 05/07/2024.
//

import Foundation

protocol RMAPICacheManagerProtocol {
    func cachedResponse(for endpoint: RMEndpoint, url: URL?) -> Data?
    func setCache(for endpoint: RMEndpoint, url: URL?, data: Data)
}
