//
//  RMServiceError.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 05/07/2024.
//

import Foundation

// MARK: - Default RMService Errors
enum RMServiceError: Error, LocalizedError {
    case failedToCreateRequest
    case failedToGetData
    case invalidURL

    var errorDescription: String? {
        switch self {
        case .failedToCreateRequest:
            return NSLocalizedString("Failed to create request", comment: "RMService")
        case .failedToGetData:
            return NSLocalizedString("Failed to get data", comment: "RMService")
        case .invalidURL:
            return NSLocalizedString("Failed to create url. Invalid URL format", comment: "RMService")
        }
    }
}
