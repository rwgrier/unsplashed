//
//  Photo.swift
//  Unsplash
//
//  Created by Grier, Ryan on 5/27/16.
//  Copyright © 2016 Ryan Grier. All rights reserved.
//

import Foundation
import UIKit

struct Photo: Codable {
    let id: String?
    let created: Date?
    let width: Int?
    let height: Int?
    let colorHex: String?
    let likes: Int?
    let likedByUser: Bool
    let links: Links?
    let user: User?
    let urls: PhotoURLs?

    private enum CodingKeys: String, CodingKey {
        case id, width, height, likes, links, user, urls
        case created = "created_at", likedByUser = "liked_by_user", colorHex = "color"
    }
}

extension Photo {
    var color: UIColor? {
        guard let hexColor = colorHex else { return nil }
        return UIColor(hex: hexColor)
    }
}
