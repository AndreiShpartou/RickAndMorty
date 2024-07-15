//
//  RMLocationDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 12/06/2024.
//

import Foundation

// MARK: - ViewModel Implementation
final class RMLocationDetailsViewViewModel: RMLocationDetailsViewViewModelProtocol {

    weak var delegate: RMLocationDetailsViewViewModelDelegate?

    private(set) var sections: [RMSectionType] = []
    private let location: RMLocationProtocol
    private let service: RMServiceProtocol

    private var characters: [RMCharacterProtocol]?

    // MARK: - Init
    init(
        location: RMLocationProtocol,
        service: RMServiceProtocol = RMService.shared
    ) {
        self.location = location
        self.service = service
    }

    // MARK: - Public
    func fetchLocationData() {
        fetchRelatedCharacters(location: location)
    }

    // Fetch character model
    func character(at index: Int) -> RMCharacterProtocol? {
        return characters?[index]
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

        group.notify(queue: .main) { [weak self] in
            self?.characters = characters
            self?.setupSections()
            self?.delegate?.didFetchLocationDetail()
        }
    }

    // MARK: - DescriptionToShare
    private func getLocationDescription() -> RMShareItem {
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
        guard let characters = characters else {
            return
        }

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
