//
//  LinkTests.swift
//  Unsplash
//
//  Created by Ryan Grier on 7/19/16.
//  Copyright © 2016 Ryan Grier. All rights reserved.
//

import XCTest
@testable import Unsplash

class LinksTests: XCTestCase {
    fileprivate let singleLink = "{ \"self\": \"https://api.unsplash.com/users/crew\", \"html\": \"https://unsplash.com/crew\", \"photos\": \"https://api.unsplash.com/users/crew/photos\", \"likes\": \"https://api.unsplash.com/users/crew/likes\"}"

    fileprivate let knownSelf = "https://api.unsplash.com/users/crew"
    fileprivate let knownHtml = "https://unsplash.com/crew"
    fileprivate let knownPhotos = "https://api.unsplash.com/users/crew/photos"
    fileprivate let knownLikes = "https://api.unsplash.com/users/crew/likes"

    func testLinksFromJson() {
        guard let json = try? JSONSerialization.jsonObject(with: singleLink.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String: AnyObject] else { fatalError() }

        let links = Links(json: json)

        XCTAssertNotNil(links)
        XCTAssertEqual(links?.selfLink, knownSelf)
        XCTAssertEqual(links?.html, knownHtml)
        XCTAssertEqual(links?.photos, knownPhotos)
        XCTAssertEqual(links?.likes, knownLikes)
    }
}
