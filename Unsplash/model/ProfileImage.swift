//
//  ProfileImage.swift
//  Unsplash
//
//  Created by Ryan Grier on 7/19/16.
//  Copyright © 2016 Ryan Grier. All rights reserved.
//

import Foundation

struct ProfileImage {
    let smallSrc: String?
    let mediumSrc: String?
    let largeSrc: String?
}

// MARK: - Profile Image JSON

extension ProfileImage {
    init?(json: [String: AnyObject]?) {
        guard let json = json else { return nil }

        smallSrc = json["small"] as? String
        mediumSrc = json["medium"] as? String
        largeSrc = json["large"] as? String
    }
}
