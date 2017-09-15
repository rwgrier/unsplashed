//
//  Profile.swift
//  Unsplash
//
//  Created by Ryan Grier on 7/19/16.
//  Copyright © 2016 Ryan Grier. All rights reserved.
//

import Foundation

struct User: Codable {
    let id: String?
    let username: String?
    let name: String?
    let profileImage: ProfileImage?
    let links: Links?
}
