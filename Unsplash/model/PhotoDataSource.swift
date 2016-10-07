//
//  PhotoDataSource.swift
//  Unsplash
//
//  Created by Grier, Ryan on 5/27/16.
//  Copyright © 2016 Ryan Grier. All rights reserved.
//

import Foundation

// Looks a lot like the AlamoFire Result, huh?
enum Result<Value, Error> {
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

let clientKey: String = "49a8aed7e2684cf4bcada609598b4eaee5adf785544e38a0f8ac8b9d4dfc69a7"
let endpoint: String = "https://api.unsplash.com/photos/curated/?client_id=\(clientKey)"

final class PhotoDataSource {
    fileprivate(set) var loadingState: LoadingState = .initial
    fileprivate(set) var cachedPhotos: [Photo] = [] // Do I need this?
}

// MARK: - Network Operations

extension PhotoDataSource {
    func loadPhotoListFromNetwork(_ completion: @escaping (Result<[Photo], NSError>) -> ()) {
        loadingState = .loading
        
        guard let jsonURL = URL(string: endpoint) else {
            self.loadingState = .error
            completion(Result.failure(NSError(domain: "UnSplash", code: -1000, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let dataTask: URLSessionDataTask = URLSession.shared.dataTask(with: jsonURL) { (data, response, error) in
            var success = false
            
            defer {
                self.loadingState = success ? .loaded : .error
            }
            
            guard let data = data else { return }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [AnyObject] else { return }
                    
                    success = true
                    let photos = self.photos(from: json)
                    self.cachedPhotos = photos
                    completion(Result.success(photos))
                } catch _ {
                    self.cachedPhotos = []
                    // In this simple case, eat it. We're not doing anything special with a JSON parse error.
                    completion(Result.failure(NSError(domain: "UnSplash", code: -1000, userInfo: [NSLocalizedDescriptionKey: "I dunno. "])))
                }
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
