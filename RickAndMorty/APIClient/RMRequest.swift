//
//  RMRequest.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 03/06/2024.
//

import Foundation

// Object that represents a single API call
final class RMRequest {

    // Desired endpoint
    let endpoint: RMEndpoint
    // Desired http method
    let httpMethod = "GET"
    // Computed API url
    var url: URL? {
        return URL(string: urlString)
    }

    // API Constants
    private enum RequestConstants {
        static let baseURL = "https://rickandmortyapi.com/api"
    }
    // Path components for API, if any
    private let pathComponents: [String]
    // Query arguments for API, if any
    private let queryParameters: [URLQueryItem]

    // Constructed url for the api request in string format
    private var urlString: String {
        var string = RequestConstants.baseURL
        string += "/"
        string += endpoint.rawValue

        pathComponents.forEach {
            string += "/\($0)"
        }

        if !queryParameters.isEmpty {
            string += "?"
            let queryArray: [String] = queryParameters.compactMap {
                guard let value = $0.value else {
                    return nil
                }
                return "\($0.name)=\(value)"
            }
            let queryString = queryArray.joined(separator: "&")

            string += queryString
        }

        return string
    }

    // MARK: - Init
    /// Construct request
    /// - Parameters:
    ///   - endpoint: Target endpoint
    ///   - pathComponents: Collection of Path components
    ///   - queryParameters: Collection of Query parameters
    init(
        endpoint: RMEndpoint,
        pathComponents: [String] = [],
        queryParameters: [URLQueryItem] = []
    ) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }

    /// Attempt to create request
    /// - Parameter url: URL to parse
    convenience init?(url: URL) {
        guard let parsed = RMURLParser.parseURL(url, baseURL: RequestConstants.baseURL) else {
            return nil
        }

        self.init(
            endpoint: parsed.endpoint,
            pathComponents: parsed.pathComponents,
            queryParameters: parsed.queryParameters
        )
    }
}
// MARK: - Request convenience
extension RMRequest {
    static let listCharactersRequests = RMRequest(endpoint: .character)
    static let listLocationsRequests = RMRequest(endpoint: .location)
    static let listEpisodesRequests = RMRequest(endpoint: .episode)
}
