//
//  RMLocationDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 12/06/2024.
//

import Foundation

final class RMLocationDetailsViewViewModel: RMLocationDetailsViewViewModelProtocol {

    weak var delegate: RMLocationDetailsViewViewModelDelegate?

    private(set) var sections: [RMSectionType] = []

    private let endpointURL: URL?
    private let service: RMServiceProtocol

    private var dataTuple: (location: RMLocationProtocol, characters: [RMCharacterProtocol])? {
        didSet {
            setupSections()
            delegate?.didFetchLocationDetail()
        }
    }

    // MARK: - Init
    init(endpointURL: URL?, service: RMServiceProtocol = RMService.shared) {
        self.endpointURL = endpointURL
        self.service = service
    }

    // MARK: - Public
    func fetchLocationData() {
        guard let url = endpointURL,
              let request = RMRequest(url: url) else {
            return
        }

        service.execute(
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

    // Fetch character model
    func character(at index: Int) -> RMCharacterProtocol? {
        return dataTuple?.characters[index]
    }

    func getDataToShare() -> [Any] {
        return [getLocationDescription()]
    }

    // MARK: - Private
    private func fetchRelatedCharacters(location: RMLocationProtocol) {
        let characterUrls = location.residents.compactMap {
            return URL(string: $0)
        }

        let requests = characterUrls.compactMap {
            return RMRequest(url: $0)
        }

        // n numbers of parallel requests
        // Notified when all done
        let group = DispatchGroup()
        var characters: [RMCharacterProtocol] = []

        requests.forEach { request in
            group.enter()
            service.execute(
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

    // MARK: - DescriptionToShare
    private func getLocationDescription() -> RMShareItem {
        guard let dataTuple = dataTuple else {
            let text = "No description"
            return RMShareItem(subject: text, details: text)
        }

        let location = dataTuple.location
        let createdString = RMDateFormatterUtils.getShortFormattedString(from: location.created)

        let subject = "Location: \(location.name)"
        let details = """
            Location Name: "\(location.name)"
            Type: "\(location.type)"
            Dimension: "\(location.dimension)"
            Created: "\(createdString)"
        """

        return RMShareItem(subject: subject, details: details)
    }

    // MARK: - SetupSections
    private func setupSections() {
        guard let dataTuple = dataTuple else {
            return
        }

        let location = dataTuple.location
        let characters = dataTuple.characters
        let createdString = RMDateFormatterUtils.getShortFormattedString(from: location.created)

        let infoViewModels = [
            RMEpisodeInfoCollectionViewCellViewModel(title: "Location Name", value: location.name),
            RMEpisodeInfoCollectionViewCellViewModel(title: "Type", value: location.type),
            RMEpisodeInfoCollectionViewCellViewModel(title: "Dimension", value: location.dimension),
            RMEpisodeInfoCollectionViewCellViewModel(title: "Created", value: createdString)
        ]

        let characterViewModels = characters.compactMap {
            RMCharacterCollectionViewCellViewModelWrapper(
                RMCharacterCollectionViewCellViewModel(
                    characterName: $0.name,
                    characterStatus: $0.status,
                    characterImageUrl: URL(string: $0.image)
                )
            )
        }

        sections = [
            .locationInfo(viewModels: infoViewModels),
            .characters(viewModels: characterViewModels)
        ]
    }
}
