//
//  ShareItem.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 29/06/2024.
//

import UIKit

class RMShareItem: NSObject, UIActivityItemSource {

    private let subject: String
    private let details: String

    init(subject: String, details: String) {
        self.subject = subject
        self.details = details
    }

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return subject
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return details
    }

    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return subject
    }
}
