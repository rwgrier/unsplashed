//
//  Links.swift
//  Unsplash
//
//  Created by Ryan Grier on 7/19/16.
//  Copyright © 2016 Ryan Grier. All rights reserved.
//

import Foundation

struct Links {
    let selfLink: String?
    let html: String?
    let photos: String?
    let likes: String?
    let download: String?
}

// MARK: - Link JSON

extension Links {
    init?(json: [String: AnyObject]?) {
        guard let json = json else { return nil }

        selfLink = json["self"] as? String
        html = json["html"] as? String
        photos = json["photos"] as? String
        likes = json["likes"] as? String
        download = json["download"] as? String
    }
}
