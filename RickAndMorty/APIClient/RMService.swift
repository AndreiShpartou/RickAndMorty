//
//  RMService.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 03/06/2024.
//

import Foundation

// Primary API service object to get Rick and Morty data
final class RMService: RMServiceProtocol {
    // Shared singleton instance
    static let shared = RMService()

    private let cacheManager: RMAPICacheManagerProtocol = RMAPICacheManager()

    // MARK: - Init
    private init() {}

    // MARK: - PublicMethods
    /// Send Rick and Morty API Call
    /// - Parameters:
    ///   - request: Request instance
    ///   - type: The type of object we expect to get back
    ///   - completion: Callback with data or error
    func execute<T: Codable>(
        _ request: RMRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        if let cachedData = cacheManager.cachedResponse(
            for: request.endpoint,
            url: request.url
        ) {
            do {
                let result = try JSONDecoder().decode(type.self, from: cachedData)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
            return
        }

        guard let urlRequest = self.getURLRequest(from: request) else {
            completion(.failure(RMServiceError.failedToCreateRequest))
            return
        }

        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? RMServiceError.failedToGetData))
                return
            }

            // Decode response
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                self?.cacheManager.setCache(
                    for: request.endpoint,
                    url: request.url,
                    data: data
                )
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    // MARK: - PrivateMethods
    private func getURLRequest(from rmRequest: RMRequest) -> URLRequest? {
        guard let url = rmRequest.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = rmRequest.httpMethod

        return request
    }
}
