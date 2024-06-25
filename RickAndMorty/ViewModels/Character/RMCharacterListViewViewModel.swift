//
//  CharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 05/06/2024.
//

import UIKit

protocol RMCharacterListViewViewModelDelegate : AnyObject {
    func didLoadInitialCharacters()
    func didLoadMoreCharacters(with newIndexPath: [IndexPath])
    
    func didSelectCharacter(_ character: RMCharacter)
}

/// View Model to handle character list view logic
final class RMCharacterListViewViewModel: NSObject {
    
    public weak var delegate: RMCharacterListViewViewModelDelegate?
    
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
    
    private var isLoadingMoreCharacters = false
    
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
    
    private var cellViewModels: [RMCharacterCollectionViewCellViewModel] = []
    
    private var apiInfo: RMGetAllCharactersResponse.Info? = nil
    
    // MARK: - Fetching characters
    /// Fetch initial set of characters(20)
    public func fetchCharacters() {
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
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    /// Paginate if additional characters are needed
    public func fetchAdditionalCharacters(url: URL) {
        isLoadingMoreCharacters = true
        guard let request = RMRequest(url: url) else {
            print("Failed to create request")
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
                case .failure(let failure):
                    print(String(describing: failure))
                    self?.isLoadingMoreCharacters = false
                }
            }
        )
    }
    
    public func fetchAdditionalCharactersWithDelay(_ delay: TimeInterval, url: URL) {
        isLoadingMoreCharacters = true
        Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak self] _ in
            self?.fetchAdditionalCharacters(url: url)
        }
    }

}

// MARK: - CollectionView DataSource
extension RMCharacterListViewViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? RMCharacterCollectionViewCell else {
            fatalError("Unsupported cell")
        }

        cell.configure(with: cellViewModels[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter,
              let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier,
                for: indexPath
              ) as? RMFooterLoadingCollectionReusableView else {
            fatalError("Unsupported")
        }
        
        footer.startAnimating()
        
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }
        
        return CGSize(
            width: collectionView.frame.width,
            height: 100
        )
    }
    
}
// MARK: - CollectionView Delegation
extension RMCharacterListViewViewModel: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let bounds = collectionView.bounds
        let width: CGFloat
        let isLandscapeMultiplier = UIDevice.isLandscape ? 0.45 : 1
        if UIDevice.isPhone {
            width = (bounds.width - 30) * isLandscapeMultiplier / 2
        } else {
            // Mac or iPad
            width = (bounds.width - 50) / 4
        }

        return CGSize(
            width: width,
            height: width * 1.5)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let character = characters[indexPath.row]
        delegate?.didSelectCharacter(character)
    }
}

// MARK: - UIScrollViewDelegate
extension RMCharacterListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator,
              !isLoadingMoreCharacters,
              !cellViewModels.isEmpty,
              let nextUrlString = apiInfo?.next,
              let url = URL(string: nextUrlString) else {
            return
        }

        let offset = scrollView.contentOffset.y
        let totalContentHeight = scrollView.contentSize.height
        let totalScrollViewFixedHeight = scrollView.frame.size.height

        if totalContentHeight != 0, offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
            fetchAdditionalCharactersWithDelay(0.1, url: url)
        }
    }
}
