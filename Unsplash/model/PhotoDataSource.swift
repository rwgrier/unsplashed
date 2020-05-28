//
//  PhotoDataSource.swift
//  Unsplash
//
//  Created by Grier, Ryan on 5/27/16.
//  Copyright © 2016 Ryan Grier. All rights reserved.
//

import Foundation

enum LoadingState {
    case initial, loading, loaded, error
}

enum UnsplashError: Error {
    case invalidURL, emptyData, invalidResponse, badHTTPResponse(statusCode: Int), invalidJSON

    var message: String {
        let message: String
        switch self {
        case .invalidURL:                   message = "The URL used was invalid. Please verify and try again."
        case .emptyData:                    message = "There was no data returned from the API."
        case .invalidResponse:              message = "Invalid response. I'm not quite sure what to do with it."
        case .invalidJSON:                  message = "Invalid JSON returned. I'm not quite sure what to do with it."
        case .badHTTPResponse(let status):  message = "Recieved a \(status) from the service."
        }

        return NSLocalizedString(message, comment: "")
    }
}

let clientKey: String = "YOUR_APPLICATION_ID_HERE"
let endpoint: String = "https://api.unsplash.com/photos/?client_id=\(clientKey)"

final class PhotoDataSource {
    private(set) var loadingState: LoadingState = .initial
    private(set) var cachedPhotos: [Photo] = [] // Do I need this?
    private(set) var serviceError: Error?

    var urlSession: URLSession = URLSession.shared
}

// MARK: - Network Operations

extension PhotoDataSource {
    func loadPhotoListFromNetwork(_ completion: @escaping (Result<[Photo], Error>) -> Void) {
        loadingState = .loading

        guard let jsonURL = URL(string: endpoint) else {
            self.loadingState = .error
            completion(Result.failure(UnsplashError.invalidURL))
            return
        }

        let dataTask: URLSessionDataTask = urlSession.dataTask(with: jsonURL) { (data, response, error) in
            var success = false
            var photos: [Photo] = []
            var error: Error?

            defer {
                self.cachedPhotos = photos
                self.loadingState = success ? .loaded : .error
                self.serviceError = error

                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(photos))
                }
            }

            guard let data = data, data.count > 0 else { error = UnsplashError.emptyData; return }
            guard let httpResponse = response as? HTTPURLResponse else { error = UnsplashError.invalidResponse; return }
            guard httpResponse.statusCode == 200 else { error = UnsplashError.badHTTPResponse(statusCode: httpResponse.statusCode); return }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                photos = try decoder.decode([Photo].self, from: data)

                success = true
            } catch let caughtError {
                error = caughtError
            }
        }

        dataTask.resume()
    }
}
