//
//  RMLocationDetailsViewViewModelProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 11/07/2024.
//

import Foundation

protocol RMLocationDetailsViewViewModelProtocol: AnyObject {
    var delegate: RMLocationDetailsViewViewModelDelegate? { get set }
    var sections: [SectionType] { get }

    func fetchLocationData()
    func character(at index: Int) -> RMCharacterProtocol?
    func getDataToShare() -> [Any]
}

protocol RMLocationDetailsViewViewModelDelegate: AnyObject {
    func didFetchLocationDetail()
}
