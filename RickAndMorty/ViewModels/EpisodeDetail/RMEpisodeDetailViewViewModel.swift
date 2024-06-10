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
    
    public private(set) var sections: [SectionType] = []
    
    private let endpointURL: URL?
    
    private var dataTuple: (RMEpisode, [RMCharacter])? {
        didSet {
            delegate?.didFetchEpisodeDetail()
        }
    }
    
    // MARK: - Init
    init(endpointURL: URL?) {
        self.endpointURL = endpointURL
    }
    
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
                episode,
                characters
            )
        }
    }
    
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
}
