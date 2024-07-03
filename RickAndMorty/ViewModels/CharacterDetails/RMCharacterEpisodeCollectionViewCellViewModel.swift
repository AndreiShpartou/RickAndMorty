//
//  RMCharacterEpisodeCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 08/06/2024.
//

import UIKit

protocol RMEpisodeDataRender {
    var episode: String { get }
    var name: String { get }
    var air_date: String { get }
}

final class RMCharacterEpisodeCollectionViewCellViewModel {

    let borderColor: UIColor

    private let episodeDataUrl: URL?
    private var isFetching = false
    private var dataBlock: ((RMEpisodeDataRender) -> Void)?

    private var episode: RMEpisode? {
        didSet {
            guard let model = episode else {
                return
            }
            dataBlock?(model)
        }
    }

    // MARK: - Init
    init(episodeDataUrl: URL?, borderColor: UIColor = .systemBlue) {
        self.episodeDataUrl = episodeDataUrl
        self.borderColor = borderColor
    }

    func registerForData(_ block: @escaping (RMEpisodeDataRender) -> Void) {
        self.dataBlock = block
    }

    // MARK: - FetchData
    func fetchEpisode() {
        guard !isFetching else {
            if let model = episode {
                dataBlock?(model)
            }

            return
        }
        guard let url = episodeDataUrl,
              let request = RMRequest(url: url) else {
            return
        }

        isFetching = true
        RMService.shared.execute(
            request,
            expecting: RMEpisode.self
        ) { [weak self] result in
                switch result {
                case .success(let model):
                    DispatchQueue.main.async {
                        self?.episode = model
                    }
                case .failure:
                    break
//                    print(String(describing: failure))
                }
        }
    }
}

// MARK: - Hashable
extension RMCharacterEpisodeCollectionViewCellViewModel: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.episodeDataUrl?.absoluteString ?? "")
    }

    static func == (lhs: RMCharacterEpisodeCollectionViewCellViewModel, rhs: RMCharacterEpisodeCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
