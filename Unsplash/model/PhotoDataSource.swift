//
//  PhotoDataSource.swift
//  Unsplash
//
//  Created by Grier, Ryan on 5/27/16.
//  Copyright © 2016 Ryan Grier. All rights reserved.
//

import Foundation

// Looks a lot like the AlamoFire Result, huh?
enum Result<Value> {
    case success(Value)
    case failure(Error)
    
    var isSuccess: Bool {
        switch self {
        case .success:  return true
        case .failure:  return false
        }
    }
    
    var isFailure: Bool {
        return !isSuccess
    }
    
    var value: Value? {
        switch self {
        case .success(let value):   return value
        case .failure:              return nil
        }
    }
    
    var error: Error? {
        switch self {
        case .success:              return nil
        case .failure(let error):   return error
        }
    }
}

enum LoadingState {
    case initial, loading, loaded, error
}

enum UnsplashError: Error {
    case invalidURL, emptyData, invalidResponse, badHTTPResponse(statusCode: Int), invalidJSON
}

let clientKey: String = "49a8aed7e2684cf4bcada609598b4eaee5adf785544e38a0f8ac8b9d4dfc69a7"
let endpoint: String = "https://api.unsplash.com/photos/curated/?client_id=\(clientKey)"

final class PhotoDataSource {
    fileprivate(set) var loadingState: LoadingState = .initial
    fileprivate(set) var cachedPhotos: [Photo] = [] // Do I need this?
}

// MARK: - Network Operations

extension PhotoDataSource {
    func loadPhotoListFromNetwork(_ completion: @escaping (Result<[Photo]>) -> ()) {
        loadingState = .loading
        
        guard let jsonURL = URL(string: endpoint) else {
            self.loadingState = .error
            completion(Result.failure(UnsplashError.invalidURL))
            return
        }
        
        let dataTask: URLSessionDataTask = URLSession.shared.dataTask(with: jsonURL) { (data, response, error) in
            var success = false
            var photos: [Photo] = []
            var error: Error?
            
            defer {
                self.cachedPhotos = photos
                self.loadingState = success ? .loaded : .error
                
                if let error = error {
                    completion(Result.failure(error))
                } else {
                    completion(Result.success(photos))
                }
            }
            
            guard let data = data else { error = UnsplashError.emptyData; return }
            guard let httpResponse = response as? HTTPURLResponse else { error = UnsplashError.invalidResponse; return }
            guard httpResponse.statusCode == 200 else { error = UnsplashError.badHTTPResponse(statusCode: httpResponse.statusCode); return }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [AnyObject] else { error = UnsplashError.invalidJSON; return }
                
                success = true
                photos = self.photos(from: json)
            } catch let caughtError {
                error = caughtError
            }
        }
        
        dataTask.resume()
    }
    
    fileprivate func photos(from json: [AnyObject]) -> [Photo] {
        var photos: [Photo] = []

        for rawPhotoJSON in json {
            guard let photoJSON = rawPhotoJSON as? [String: AnyObject] else { continue }
            if let photo = Photo(json: photoJSON) {
                photos.append(photo)
            }
        }
        
        return photos
    }
}
