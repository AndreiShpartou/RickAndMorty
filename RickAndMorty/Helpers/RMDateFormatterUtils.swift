//
//  RMDateFormatterUtils.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 05/07/2024.
//

import Foundation

enum RMDateFormatterUtils {
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.SSSSZ"
        formatter.timeZone = .current

        return formatter
    }()

    static let shortFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.timeZone = .current

        return formatter
    }()

    static func getShortFormattedString(from dateString: String) -> String {
        if let date = formatter.date(from: dateString) {
            return shortFormatter.string(from: date)
        }
        return dateString
    }
}
