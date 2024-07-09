//
//  CharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 05/06/2024.
//

import UIKit

// MARK: - ViewModel Implementation
// View Model to handle character list view logic
final class RMCharacterListViewViewModel: RMCharacterListViewViewModelProtocol {

    weak var delegate: RMCharacterListViewViewModelDelegate?

    var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }

    var nextUrlString: String? {
        return apiInfo?.next
    }

    private(set) var cellViewModels: [RMCharacterCollectionViewCellViewModelWrapper] = []

    private(set) var isLoadingMoreCharacters = false

    private var service: RMServiceProtocol

    private var characters: [RMCharacterProtocol] = [] {
        didSet {
            for character in characters {
                let viewModel = RMCharacterCollectionViewCellViewModelWrapper(
                    RMCharacterCollectionViewCellViewModel(
                        characterName: character.name,
                        characterStatus: character.status,
                        characterImageUrl: URL(string: character.image)
                    )
                )

                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }

    private var apiInfo: RMGetAllCharactersResponse.Info?

    // MARK: - Init
    init(service: RMServiceProtocol = RMService.shared) {
        self.service = service
    }

    // MARK: - Fetching characters
    // Fetch initial set of characters(20)
    func fetchCharacters() {
        service.execute(
            .listCharactersRequests,
            expecting: RMGetAllCharactersResponse.self
        ) { [weak self] result in
            switch result {
            case .success(let responseModel):
                self?.handleInitialFetch(responseModel)
            case .failure(let error):
                NSLog("Failed to fetch initial set of characters: \(error.localizedDescription)")
            }
        }
    }

    // Paginate if additional characters are needed
    func fetchAdditionalCharacters(url: URL) {
        isLoadingMoreCharacters = true
        guard let request = RMRequest(url: url) else {
            NSLog(RMServiceError.failedToCreateRequest.localizedDescription)
            isLoadingMoreCharacters = false
            return
        }

        service.execute(
            request,
            expecting: RMGetAllCharactersResponse.self,
            completion: { [weak self] result in
                switch result {
                case .success(let responseModel):
                    self?.appendNewCharacters(responseModel)
                case .failure(let error):
                    NSLog("Failed to fetch additional characters: \(error.localizedDescription)")
                    self?.isLoadingMoreCharacters = false
                }
            }
        )
    }

    func getCharacter(at index: Int) -> RMCharacterProtocol {
        return characters[index]
    }

    // MARK: - Delay
    func fetchAdditionalCharactersWithDelay(_ delay: TimeInterval, url: URL) {
        isLoadingMoreCharacters = true
        Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak self] _ in
            self?.fetchAdditionalCharacters(url: url)
        }
    }

    // MARK: - PrivateMethods
    private func handleInitialFetch(_ responseModel: RMGetAllCharactersResponse) {
        self.apiInfo = responseModel.info
        self.characters.append(contentsOf: responseModel.results)

        DispatchQueue.main.async {
            self.delegate?.didLoadInitialCharacters()
        }
    }

    private func appendNewCharacters(_ responseModel: RMGetAllCharactersResponse) {
        let moreResults = responseModel.results
        let originalCount = characters.count
        let newCount = moreResults.count
        let total = originalCount + newCount
        let startingIndex = total - newCount
        let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex + newCount)).compactMap {
            return IndexPath(row: $0, section: 0)
        }

        self.apiInfo = responseModel.info
        self.characters.append(contentsOf: moreResults)

        DispatchQueue.main.async {
            self.delegate?.didLoadMoreCharacters(with: indexPathsToAdd)
            self.isLoadingMoreCharacters = false
        }
    }
}
