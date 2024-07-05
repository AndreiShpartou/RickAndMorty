//
//  CharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 05/06/2024.
//

import UIKit

// View Model to handle character list view logic
// MARK: - ViewModel Implementation
final class RMCharacterListViewViewModel: RMCharacterListViewViewModelProtocol {

    weak var delegate: RMCharacterListViewViewModelDelegate?

    var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }

    var nextUrlString: String? {
        return apiInfo?.next
    }

    private(set) var cellViewModels: [RMCharacterCollectionViewCellViewModel] = []

    private(set) var isLoadingMoreCharacters = false

    private var characters: [RMCharacter] = [] {
        didSet {
            for character in characters {
                let viewModel = RMCharacterCollectionViewCellViewModel(
                    characterName: character.name,
                    characterStatus: character.status,
                    characterImageUrl: URL(string: character.image)
                )

                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }

    private var apiInfo: RMGetAllCharactersResponse.Info?

    // MARK: - Fetching characters
    // Fetch initial set of characters(20)
    func fetchCharacters() {
        RMService.shared.execute(
            .listCharactersRequests,
            expecting: RMGetAllCharactersResponse.self
        ) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                let info = responseModel.info

                self?.apiInfo = info
                self?.characters = results

                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacters()
                }
            case .failure:
                break
//                print(String(describing: error))
            }
        }
    }

    // Paginate if additional characters are needed
    func fetchAdditionalCharacters(url: URL) {
        isLoadingMoreCharacters = true
        guard let request = RMRequest(url: url) else {
//            print("Failed to create request")
            isLoadingMoreCharacters = false
            return
        }

        RMService.shared.execute(
            request,
            expecting: RMGetAllCharactersResponse.self,
            completion: { [weak self] result in
                switch result {
                case .success(let responseModel):
                    let moreResults = responseModel.results
                    let info = responseModel.info

                    let originalCount = self?.characters.count ?? 0
                    let newCount = moreResults.count
                    let total = originalCount + newCount
                    let startingIndex = total - newCount
                    let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex + newCount)).compactMap {
                        return IndexPath(row: $0, section: 0)
                    }

                    self?.apiInfo = info
                    self?.characters.append(contentsOf: moreResults)

                    DispatchQueue.main.async {
                        self?.delegate?.didLoadMoreCharacters(with: indexPathsToAdd)
                        self?.isLoadingMoreCharacters = false
                    }
                case .failure:
//                    print(String(describing: failure))
                    self?.isLoadingMoreCharacters = false
                }
            }
        )
    }

    func getCharacter(at index: Int) -> RMCharacter {
        return characters[index]
    }

    // MARK: - Delay
    func fetchAdditionalCharactersWithDelay(_ delay: TimeInterval, url: URL) {
        isLoadingMoreCharacters = true
        Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak self] _ in
            self?.fetchAdditionalCharacters(url: url)
        }
    }
}
