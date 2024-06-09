//
//  RMEpisodeDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 09/06/2024.
//

import Foundation

class RMEpisodeDetailViewViewModel {
    private let endpointURL: URL?
    
    // MARK: - Init
    init(endpointURL: URL?) {
        self.endpointURL = endpointURL
        fetchEpisodeData()
    }
    
    private func fetchEpisodeData() {
        guard let url = endpointURL,
              let request = RMRequest(url: url) else {
            return
        }
        
        RMService.shared.execute(
            request,
            expecting: RMEpisode.self) { result in
                switch result {
                case .success(let success):
                        print(String(describing: success))
                case .failure(let failure):
                    break
                }
            }
    }
}
