//
//  PhotoCell.swift
//  Unsplash
//
//  Created by Ryan Grier on 7/25/16.
//  Copyright © 2016 Ryan Grier. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    @IBOutlet fileprivate var imageView: UIImageView!
    @IBOutlet fileprivate var label: UILabel!
    
    fileprivate var request: URLSessionDataTask?
    
    func setupCell(photo: Photo) {
        label.adjustsFontForContentSizeCategory = true
        label.text = photo.user?.name
        
        guard let urlString = photo.smallUrlString, let url = URL(string: urlString) else { return }
        request?.cancel()
        request = URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data: Data?, response: URLResponse?, error: Error?) in
            guard let weakSelf = self else { return }
            guard let data = data, let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                weakSelf.imageView.image = image
            }
        })
        
        request?.resume()
    }
}
