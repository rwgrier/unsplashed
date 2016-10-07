//
//  GalleryViewController.swift
//  Unsplash
//
//  Created by Grier, Ryan on 5/26/16.
//  Copyright © 2016 Ryan Grier. All rights reserved.
//

import UIKit

class GalleryViewController: UICollectionViewController {
    fileprivate let photoDataSource = PhotoDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        (collectionView?.collectionViewLayout as? UICollectionViewFlowLayout)?.estimatedItemSize = CGSize(width: 320, height: 279)
        
        loadPhotoInfoFromNetwork()
    }
    
    fileprivate func loadPhotoInfoFromNetwork() {
        // Kick off the network request
        photoDataSource.loadPhotoListFromNetwork { [weak self] (result: Result<[Photo], NSError>) in
            switch result {
            case .success(let photos):
                print("Photo Count: \(photos.count)")
//                print("Photos: \(photos)")
                DispatchQueue.main.async {
                    self?.collectionView?.reloadData()
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension GalleryViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("count: \(photoDataSource.cachedPhotos.count)")
        return photoDataSource.cachedPhotos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "thumbnailCell", for: indexPath) as! PhotoCell
        let photo = photoDataSource.cachedPhotos[indexPath.row]
        
        photoCell.setupCell(photo: photo)
        
        return photoCell
    }
}

// MARK: - UICollectionViewDelegate

extension GalleryViewController {
    
}
