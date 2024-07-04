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
    private enum Constants {
        static let baseURL = "https://rickandmortyapi.com/api"
    }
    // Path components for API, if any
    private let pathComponents: [String]
    // Query arguments for API, if any
    private let queryParameters: [URLQueryItem]
    // Constructed url for the api request in string format

    private var urlString: String {
        var string = Constants.baseURL
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
        let string = url.absoluteString
        if !string.contains(Constants.baseURL) {
            return nil
        }

        let trimmed = string.replacingOccurrences(of: Constants.baseURL + "/", with: "")
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
                    self.init(endpoint: rmEndpoint, pathComponents: pathComponents)
                    return
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
                    self.init(endpoint: rmEndpoint, queryParameters: queryItems)
                    return
                }
            }
        }

        return nil
    }
}
// MARK: - Request convenience
extension RMRequest {
    static let listCharactersRequests = RMRequest(endpoint: .character)
    static let listLocationsRequests = RMRequest(endpoint: .location)
    static let listEpisodesRequests = RMRequest(endpoint: .episode)
}
