//
//  RMDynamicOption.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 12/07/2024.
//

import Foundation

// Options for filtering
enum RMDynamicOption: String {
    case status = "Status"
    case gender = "Gender"
    case locationType = "Location Type"

    var queryArgument: String {
        switch self {
        case .status:
            return "status"
        case .gender:
            return "gender"
        case .locationType:
            return "type"
        }
    }

    var choices: [String] {
        switch self {
        case .status:
            return ["alive", "dead", "unknown"]
        case .gender:
            return ["male", "female", "genderless", "unknown"]
        case .locationType:
            return ["cluster", "planet", "microverse"]
        }
    }
}
