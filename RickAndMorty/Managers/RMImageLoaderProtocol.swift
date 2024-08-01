//
//  RMImageLoaderProtocol.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 05/07/2024.
//

import Foundation

protocol RMImageLoaderProtocol {
    func downloadImage(_ url: URL, completion: @escaping (Result<Data, Error>, URL?) -> Void)
}
