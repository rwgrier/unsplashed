//
//  Profile.swift
//  Unsplash
//
//  Created by Ryan Grier on 7/19/16.
//  Copyright © 2016 Ryan Grier. All rights reserved.
//

import Foundation

struct User {
    let id: String?
    let username: String?
    let name: String?
    let profileImage: ProfileImage?
    let links: Links?
}

// MARK: - User JSON

extension User {
    init?(json: [String: AnyObject]?) {
        guard let json = json else { return nil }

        id = json["id"] as? String
        username = json["username"] as? String
        name = json["name"] as? String
        profileImage = ProfileImage(json: json["profile_image"] as? [String: AnyObject])
        links = Links(json: json["links"] as? [String: AnyObject])
    }
}
