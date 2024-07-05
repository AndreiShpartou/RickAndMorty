//
//  ImageLoader.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 07/06/2024.
//

import Foundation

final class RMImageLoader: RMImageLoaderProtocol {

    static let shared = RMImageLoader()

    private var imageDataCache = NSCache<NSString, NSData>()

    private init() {}

    /// Get image content with URL
    /// - Parameters:
    ///   - url: Source url
    ///   - completion: Callback
    func downloadImage(_ url: URL, completion: @escaping (Result<Data, Error>, URL?) -> Void) {
        let key = url.absoluteString as NSString
        if let data = imageDataCache.object(forKey: key) {
            completion(.success(data as Data), url) // NSData == Data | NSString == String
            return
        }

        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)), nil)
                return
            }

            let value = data as NSData
            self?.imageDataCache.setObject(value, forKey: key)

            completion(.success(data), url)
        })
        task.resume()
    }
}
