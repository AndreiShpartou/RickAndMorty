//
//  RMURLParser.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 05/07/2024.
//

import Foundation

enum RMURLParser {
    static func parseURL(_ url: URL, baseURL: String) -> (endpoint: RMEndpoint, pathComponents: [String], queryParameters: [URLQueryItem])? {
        let string = url.absoluteString
        if !string.contains(baseURL) {
            return nil
        }

        let trimmed = string.replacingOccurrences(of: baseURL + "/", with: "")
        // Request with path components
        if trimmed.contains("/") {
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty {
                let endpointString = components[0] // Endpoint
                var pathComponents = [String]()
                if components.count > 1 {
                    pathComponents = components
                    pathComponents.removeFirst()
                }
                if let rmEndpoint = RMEndpoint(
                    rawValue: endpointString
                ) {
                    return (rmEndpoint, pathComponents, [])
                }
            }
        }
        // Request with query parameters
        else if trimmed.contains("?") {
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty, components.count >= 2 {
                let endpointString = components[0]
                let queryItemString = components[1]
                // value=name&param=surname
                let queryItems: [URLQueryItem] = queryItemString.components(separatedBy: "&").compactMap({
                    guard $0.contains("=") else {
                        return nil
                    }

                    let parts = $0.components(separatedBy: "=")
                    return URLQueryItem(
                        name: parts[0],
                        value: parts[1]
                    )
                })
                if let rmEndpoint = RMEndpoint(rawValue: endpointString) {
                    return (rmEndpoint, [], queryItems)
                }
            }
        }

        return nil
    }
}
