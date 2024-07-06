//
//  RMLocationDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 12/06/2024.
//

import Foundation

protocol RMLocationDetailViewViewModelDelegate: AnyObject {
    func didFetchLocationDetail()
}

final class RMLocationDetailViewViewModel {

    weak var delegate: RMLocationDetailViewViewModelDelegate?

    enum SectionType {
        case information(viewModels: [RMEpisodeInfoCollectionViewCellViewModel])
        case characters(viewModels: [RMCharacterCollectionViewCellViewModel])
    }

    private(set) var cellViewModels: [SectionType] = []

    private let endpointURL: URL?

    private var dataTuple: (location: RMLocation, characters: [RMCharacter])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchLocationDetail()
        }
    }

    // MARK: - Init
    init(endpointURL: URL?) {
        self.endpointURL = endpointURL
    }
}

// MARK: - Public
extension RMLocationDetailViewViewModel {

    // MARK: - Fetch location model
    func fetchLocationData() {
        guard let url = endpointURL,
              let request = RMRequest(url: url) else {
            return
        }

        RMService.shared.execute(
            request,
            expecting: RMLocation.self
        ) { [weak self] result in
                switch result {
                case .success(let model):
                    self?.fetchRelatedCharacters(location: model)
                case .failure(let error):
                    NSLog("Failed to fetch location detail \(error.localizedDescription)")
                }
        }
    }

    func character(at index: Int) -> RMCharacter? {
        guard let dataTuple = dataTuple else {
            return nil
        }

        return dataTuple.characters[index]
    }

    func getDataToShare() -> [Any] {
        return [getLocationDescription()]
    }
}

// MARK: - Private
extension RMLocationDetailViewViewModel {
    private func fetchRelatedCharacters(location: RMLocation) {
        let characterUrls = location.residents.compactMap {
            return URL(string: $0)
        }

        let requests = characterUrls.compactMap {
            return RMRequest(url: $0)
        }

        // n numbers of parallel requests
        // Notified when all done
        let group = DispatchGroup()
        var characters: [RMCharacter] = []

        requests.forEach { request in
            group.enter()
            RMService.shared.execute(
                request,
                expecting: RMCharacter.self
            ) { result in
                    defer {
                        group.leave()
                    }

                    switch result {
                    case .success(let model):
                        characters.append(model)
                    case .failure(let error):
                        NSLog("Failed to fetch location detail related characters: \(error.localizedDescription)")
                    }
            }
        }

        group.notify(queue: .main) {
            self.dataTuple = (
                location: location,
                characters: characters
            )
        }
    }

    private func createCellViewModels() {
        guard let dataTuple = dataTuple else {
            return
        }

        let location = dataTuple.location
        let characters = dataTuple.characters
        var createdString = location.created
        if let date = RMDateFormatterUtils.formatter.date(
            from: location.created
        ) {
            createdString = RMDateFormatterUtils.shortFormatter.string(
                from: date
            )
        }

        cellViewModels = [
            .information(viewModels: [
                .init(title: "Location Name", value: location.name),
                .init(title: "Type", value: location.type),
                .init(title: "Dimension", value: location.dimension),
                .init(title: "Created", value: createdString)
            ]),
            .characters(viewModels: characters.compactMap {
                RMCharacterCollectionViewCellViewModel(
                    characterName: $0.name,
                    characterStatus: $0.status,
                    characterImageUrl: URL(string: $0.image)
                )
            })
        ]
    }

    private func getLocationDescription() -> RMShareItem {
        guard let dataTuple = dataTuple else {
            let text = "No description"
            return RMShareItem(subject: text, details: text)
        }

        let location = dataTuple.location
        var createdString = location.created
        if let date = RMDateFormatterUtils.formatter.date(
            from: location.created
        ) {
            createdString = RMDateFormatterUtils.shortFormatter.string(
                from: date
            )
        }

        let subject = "Location: \(location.name)"
        let details = """
            Location Name: "\(location.name)"
            Type: "\(location.type)"
            Dimension: "\(location.dimension)"
            Created: "\(createdString)"
        """

        return RMShareItem(subject: subject, details: details)
    }
}
