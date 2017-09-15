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

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        (collectionView?.collectionViewLayout as? UICollectionViewFlowLayout)?.estimatedItemSize = CGSize(width: 320, height: 279)
        NotificationCenter.default.addObserver(self, selector: #selector(GalleryViewController.fontSizeChanged(_:)), name: .UIContentSizeCategoryDidChange, object: nil)

        loadPhotoInfoFromNetwork()
    }

    fileprivate func loadPhotoInfoFromNetwork() {
        // Kick off the network request
        photoDataSource.loadPhotoListFromNetwork { [weak self] (result: Result<[Photo]>) in
            guard let weakSelf = self else { return }

            switch result {
            case .failure(let error):
                let title = NSLocalizedString("Photos Error", comment: "")
                var message = NSLocalizedString("An unknown error has occurred", comment: "")

                if let unsplashError = error as? UnsplashError {
                    message = unsplashError.message
                }

                let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alertView.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: nil))
                alertView.addAction(UIAlertAction(title: NSLocalizedString("Retry", comment: ""), style: .default, handler: { (_) in
                    weakSelf.loadPhotoInfoFromNetwork()
                }))

                weakSelf.present(alertView, animated: true, completion: nil)
            case .success:  break
            }

            DispatchQueue.main.async {
                weakSelf.collectionView?.reloadData()
            }
        }
    }

    @objc internal func fontSizeChanged(_ notification: Notification) {
        collectionView?.reloadData()
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
        guard let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "thumbnailCell", for: indexPath) as? PhotoCell else { fatalError("The cell should be a PhotoCell") }
        let photo = photoDataSource.cachedPhotos[indexPath.row]

        photoCell.setupCell(photo: photo)
        return photoCell
    }
}
