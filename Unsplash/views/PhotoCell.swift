//
//  PhotoCell.swift
//  Unsplash
//
//  Created by Ryan Grier on 7/25/16.
//  Copyright © 2016 Ryan Grier. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var label: UILabel!
    
    fileprivate var request: URLSessionDataTask?
    
    func setupCell(photo: Photo) {
        label.text = photo.user?.name
        
        guard let urlString = photo.smallUrlString, let url = URL(string: urlString) else { return }
        request = URLSession.shared.dataTask(with: url, completionHandler: { [unowned self] (data: Data?, response: URLResponse?, error: Error?) in
            guard let data = data, let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        })
        
        request?.resume()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        request?.cancel()
        imageView.image = nil
    }
}
