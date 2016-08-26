//
//  Photo.swift
//  Unsplash
//
//  Created by Grier, Ryan on 5/27/16.
//  Copyright © 2016 Ryan Grier. All rights reserved.
//

import Foundation
import UIKit

struct Photo {
    let id: String?
    let created: Date?
    let width: Int?
    let height: Int?
    let color: UIColor?
    let likes: Int?
    let likedByUser: Bool
    let links: Links?
    let user: User?
    
    let rawUrlString: String?
    let fullUrlString: String?
    let regularUrlString: String?
    let smallUrlString: String?
    let thumbnailUrlString: String?
    
    // TODO: Add categories
}

// MARK: - Photo JSON

extension Photo {
    init?(json: [String: AnyObject]?) {
        guard let json = json else { return nil }
        let dateFormatter = ISO8601DateFormatter()
        
        id = json["id"] as? String
        width = json["width"] as? Int
        height = json["height"] as? Int
        likes = json["likes"] as? Int
        likedByUser = (json["liked_by_user"] as? Bool) ?? false
        
        if let jsonDate = json["created_at"] as? String {
            created = dateFormatter.date(from: jsonDate)
        } else {
            created = Date()
        }
        
        if let hexColor = json["color"] as? String {
            color = UIColor(hex: hexColor)
        } else {
            color = nil
        }
        
        links = Links(json: json["links"] as? [String: AnyObject])
        user = User(json: json["user"] as? [String: AnyObject])
        
        if let urls = json["urls"] as? [String: String] {
            rawUrlString = urls["raw"]
            fullUrlString = urls["full"]
            regularUrlString = urls["regular"]
            smallUrlString = urls["small"]
            thumbnailUrlString = urls["thumb"]
        } else {
            rawUrlString = nil
            fullUrlString = nil
            regularUrlString = nil
            smallUrlString = nil
            thumbnailUrlString = nil
        }
    }
}


// MARK: - Links JSON

//{
//    "id": "f0uhh2B9Mws",
//    "created_at": "2016-05-27T10:20:15-04:00",
//    "width": 4104,
//    "height": 2736,
//    "color": "#EBEDEC",
//    "likes": 6,
//    "liked_by_user": false,
//    "user": {
//        "id": "cb21Q_FwOvc",
//        "username": "rndmben13",
//        "name": "Ben Bowens",
//        "profile_image": {
//            "small": "https://images.unsplash.com/profile-fb-1464358513-6b7df0661085.jpg?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=32&w=32&s=983f2a98aee633f962a89c1bdec0cb29",
//            "medium": "https://images.unsplash.com/profile-fb-1464358513-6b7df0661085.jpg?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=64&w=64&s=a799ec06947ac87e22d3f5f212fb1206",
//            "large": "https://images.unsplash.com/profile-fb-1464358513-6b7df0661085.jpg?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=128&w=128&s=3433e888a6b1bd62f6988353d2f6f34d"
//        },
//        "links": {
//            "self": "https://api.unsplash.com/users/rndmben13",
//            "html": "http://unsplash.com/@rndmben13",
//            "photos": "https://api.unsplash.com/users/rndmben13/photos",
//            "likes": "https://api.unsplash.com/users/rndmben13/likes"
//        }
//    },
//    "current_user_collections": [],
//    "urls": {
//        "raw": "https://images.unsplash.com/photo-1464358784099-c4156b56a7ec",
//        "full": "https://images.unsplash.com/photo-1464358784099-c4156b56a7ec?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&s=3f756af70959bcd7f290c3e8eb7f93ea",
//        "regular": "https://images.unsplash.com/photo-1464358784099-c4156b56a7ec?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=1080&fit=max&s=bf0bf8086c25a9041e1e36ae13b826ca",
//        "small": "https://images.unsplash.com/photo-1464358784099-c4156b56a7ec?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=400&fit=max&s=d908e425405a827a5bcea87209c257f3",
//        "thumb": "https://images.unsplash.com/photo-1464358784099-c4156b56a7ec?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=200&fit=max&s=a1208356f2406325f120395638366110"
//    },
//    "categories": [
//    {
//    "id": 4,
//    "title": "Nature",
//    "photo_count": 45900,
//    "links": {
//    "self": "https://api.unsplash.com/categories/4",
//    "photos": "https://api.unsplash.com/categories/4/photos"
//    }
//    }
//    ],
//    "links": {
//        "self": "https://api.unsplash.com/photos/f0uhh2B9Mws",
//        "html": "http://unsplash.com/photos/f0uhh2B9Mws",
//        "download": "http://unsplash.com/photos/f0uhh2B9Mws/download"
//    }
//},
