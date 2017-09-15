//
//  PhotoURLs.swift
//  Unsplash
//
//  Created by Ryan Grier on 6/16/17.
//  Copyright © 2017 Ryan Grier. All rights reserved.
//

import Foundation

struct PhotoURLs: Codable {
    let raw: URL?
    let full: URL?
    let regular: URL?
    let small: URL?
    let thumb: URL?
}
