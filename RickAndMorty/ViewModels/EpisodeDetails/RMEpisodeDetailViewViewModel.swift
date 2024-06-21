//
//  RMEpisodeDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 09/06/2024.
//

import Foundation

protocol RMEpisodeDetailViewViewModelDelegate: AnyObject {
    func didFetchEpisodeDetail()
}

final class RMEpisodeDetailViewViewModel {
    public weak var delegate: RMEpisodeDetailViewViewModelDelegate?
    
    enum SectionType {
        case information(viewModels: [RMEpisodeInfoCollectionViewCellViewModel])
        case characters(viewModels: [RMCharacterCollectionViewCellViewModel])
    }
    
    public private(set) var cellViewModels: [SectionType] = []
    
    private let endpointURL: URL?
    
    private var dataTuple: (episode: RMEpisode, characters: [RMCharacter])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchEpisodeDetail()
        }
    }
    
    // MARK: - Init
    init(endpointURL: URL?) {
        self.endpointURL = endpointURL
    }
}

// MARK: - Public
extension RMEpisodeDetailViewViewModel {
    
    // MARK: - Fetch episode model
    public func fetchEpisodeData() {
        guard let url = endpointURL,
              let request = RMRequest(url: url) else {
            return
        }
        
        RMService.shared.execute(
            request,
            expecting: RMEpisode.self) { [weak self] result in
                switch result {
                case .success(let model):
                    self?.fetchRelatedCharacters(episode: model)
                case .failure:
                    break
                }
            }
    }
    
    public func character(at index: Int) -> RMCharacter? {
        guard let dataTuple = dataTuple else {
            return nil
        }
        
        return dataTuple.characters[index]
    }
}

// MARK: - Private
extension RMEpisodeDetailViewViewModel {
    private func fetchRelatedCharacters(episode: RMEpisode) {
        let characterUrls = episode.characters.compactMap {
            return URL(string: $0)
        }
        
        let requests = characterUrls.compactMap {
            return RMRequest(url: $0)
        }
        
        // n numbers of parallel requests
        // Notified when all done
        let group  = DispatchGroup()
        var characters: [RMCharacter] = []
        
        requests.forEach { request in
            group.enter()
            RMService.shared.execute(
                request,
                expecting: RMCharacter.self) { result in
                    defer {
                        group.leave()
                    }
                    
                    switch result {
                    case .success(let model):
                        characters.append(model)
                    case .failure:
                        break
                    }
                }
        }
        
        group.notify(queue: .main) {
            self.dataTuple = (
                episode: episode,
                characters: characters
            )
        }
    }
    
    private func createCellViewModels() {
        guard let dataTuple = dataTuple else {
            return
        }
        
        let episode = dataTuple.episode
        let characters = dataTuple.characters
        var createdString = episode.created
        if let date = RMCharacterInfoCollectionViewCellViewModel.dateFormatter.date(
            from: episode.created
        ) {
            createdString = RMCharacterInfoCollectionViewCellViewModel.shortDateFormatter.string(
                from: date
            )
        }
        
        cellViewModels  = [
            .information(viewModels: [
                .init(title: "Episode Name", value: episode.name),
                .init(title: "Air Date", value: episode.air_date),
                .init(title: "Episode", value: episode.episode),
                .init(title: "Created", value: createdString)
            ]),
            .characters(viewModels: characters.compactMap({
                RMCharacterCollectionViewCellViewModel(
                    characterName: $0.name,
                    characterStatus: $0.status,
                    characterImageUrl: URL(string: $0.image)
                )
            }))
        ]
    }
}
