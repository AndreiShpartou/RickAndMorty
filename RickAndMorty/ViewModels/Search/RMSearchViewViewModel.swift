//
//  RMSearchViewViewModel.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 13/06/2024.
//

import Foundation

// Responsibilities
// - Show search results
// - Show no results view
// - Kick off API requests

final class RMSearchViewViewModel {
    let config: RMSearchViewController.Config
    
    private var optionMapUpdateBlock: (((RMSearchInputViewViewModel.DynamicOption, String)) -> Void)?
    private var searResultHandler: (() -> Void)?
    
    private var optionMap: [RMSearchInputViewViewModel.DynamicOption: String] = [:]
    private var searchText: String = ""
    
    // MARK: - Init
    init(config: RMSearchViewController.Config) {
        self.config = config
    }
    
    // MARK: - Public
    public func set(value: String, for option: RMSearchInputViewViewModel.DynamicOption) {
        optionMap[option] = value
        let tuple = (option, value)
        optionMapUpdateBlock?(tuple)
    }
    
    public func set(query text: String) {
        self.searchText = text
    }
    
    public func registerOptionChangeBlock(
        _ block: @escaping ((RMSearchInputViewViewModel.DynamicOption, String)) -> Void
    ) {
        self.optionMapUpdateBlock = block
    }
    
    public func registerSearchResultHandler(_ block: @escaping () -> Void) {
        self.searResultHandler = block
    }
    
    public func executeSearch() {
        // Build arguments
        var queryParams: [URLQueryItem] = [
            URLQueryItem(name: "name", value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        ]
        
        // Add options
        queryParams.append(contentsOf: optionMap.enumerated().map({ _, element in
            let key = element.key
            let value = element.value
            return URLQueryItem(name: key.queryArgument, value: value)
        }))
        
        // Create request
        let request = RMRequest(
            endpoint: config.type.endpoint,
            queryParameters: queryParams
        )
        
        print(request.url?.absoluteString ?? "")
        
        RMService.shared.execute(
            request,
            expecting: RMGetAllCharactersResponse.self) { result in
                // Notify view of results, no results, or error
                switch result {
                case .success(let model):
                    print(String(describing: model.results.count))
                case .failure(let failure):
                    print(String(describing: failure))
                }
            }
    }
}
