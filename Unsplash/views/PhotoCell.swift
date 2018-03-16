//
//  PhotoCell.swift
//  Unsplash
//
//  Created by Ryan Grier on 7/25/16.
//  Copyright © 2016 Ryan Grier. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var label: UILabel!

    private var request: URLSessionDataTask?

    func setupCell(photo: Photo) {
        label.adjustsFontForContentSizeCategory = true
        label.text = photo.user?.name

        guard let url = photo.urls?.small else { return }
        request?.cancel()
        request = URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data: Data?, _, _) in
            guard let weakSelf = self else { return }
            guard let data = data, let image = UIImage(data: data) else { return }

            DispatchQueue.main.async {
                weakSelf.imageView.image = image
            }
        })

        request?.resume()
    }
}
