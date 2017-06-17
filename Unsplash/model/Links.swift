//
//  Links.swift
//  Unsplash
//
//  Created by Ryan Grier on 7/19/16.
//  Copyright © 2016 Ryan Grier. All rights reserved.
//

import Foundation

struct Links: Codable {
    let `self`: URL?
    let html: URL?
    let photos: URL?
    let likes: URL?
    let download: URL?
    let portfolio: URL?
}
