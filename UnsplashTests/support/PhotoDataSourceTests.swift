//
//  PhotoDataSourceTests.swift
//  UnsplashTests
//
//  Created by Ryan Grier on 5/6/18.
//  Copyright © 2018 Ryan Grier. All rights reserved.
//

import XCTest
import Mocker
@testable import Unsplash

class PhotoDataSourceTests: XCTestCase {
    private var urlSession: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        return URLSession(configuration: configuration)
    }
}

// MARK: - Cached Photo Test

extension PhotoDataSourceTests {
    func testLoadPhotoListFromNetwork_cachedValues_passing() {
        let expectation = self.expectation(description: "loading photos from network.")
        let originalURL = URL(string: "https://api.unsplash.com/photos/?client_id=UNITTESTS")!

        Mock(url: originalURL, ignoreQuery: true, dataType: .json, statusCode: 200, data: [
            .get: MockData.validJSON.data
            ]).register()

        let dataSource = PhotoDataSource()
        dataSource.urlSession = urlSession
        dataSource.loadPhotoListFromNetwork { (results) in
            let photos = try? results.get()
            XCTAssertNotNil(photos)
            guard photos != nil else { return }

            let photoCount = dataSource.cachedPhotos.count
            XCTAssertEqual(1, photoCount)

            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0, handler: nil)
    }
}

// MARK: - Network Tests

extension PhotoDataSourceTests {
    func testLoadPhotoListFromNetwork_validData_passing() {
        let expectation = self.expectation(description: "loading photos from network.")
        let originalURL = URL(string: "https://api.unsplash.com/photos/?client_id=UNITTESTS")!

        Mock(url: originalURL, ignoreQuery: true, dataType: .json, statusCode: 200, data: [
            .get: MockData.validJSON.data
        ]).register()

        let dataSource = PhotoDataSource()
        dataSource.urlSession = urlSession
        dataSource.loadPhotoListFromNetwork { (results) in
            let photos = try? results.get()
            XCTAssertNotNil(photos)
            let photoCount = photos?.count ?? 0
            XCTAssertEqual(1, photoCount)

            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testLoadPhotoListFromNetwork_validDataMultiplePhotos_passing() {
        let expectation = self.expectation(description: "loading photos from network.")
        let originalURL = URL(string: "https://api.unsplash.com/photos/?client_id=UNITTESTS")!

        Mock(url: originalURL, ignoreQuery: true, dataType: .json, statusCode: 200, data: [
            .get: MockData.validTwoPhotoJSON.data
            ]).register()

        let dataSource = PhotoDataSource()
        dataSource.urlSession = urlSession
        dataSource.loadPhotoListFromNetwork { (results) in
            let photos = try? results.get()
            XCTAssertNotNil(photos)
            let photoCount = photos?.count ?? 0
            XCTAssertEqual(2, photoCount)

            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testLoadPhotoListFromNetwork_serverError_failure() {
        let expectation = self.expectation(description: "loading photos from network.")
        let originalURL = URL(string: "https://api.unsplash.com/photos/?client_id=UNITTESTS")!

        Mock(url: originalURL, ignoreQuery: true, dataType: .json, statusCode: 500, data: [
            .get: MockData.validTwoPhotoJSON.data
            ]).register()

        let dataSource = PhotoDataSource()
        dataSource.urlSession = urlSession
        dataSource.loadPhotoListFromNetwork { (results) in
            guard case .failure(let error as UnsplashError) = results else { return }
            switch error {
            case .badHTTPResponse(statusCode: 500):
                expectation.fulfill()
            default:
                XCTFail("unexpected error: \(error)")
            }
        }

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testLoadPhotoListFromNetwork_emptyData_failure() {
        let expectation = self.expectation(description: "loading photos from network.")
        let originalURL = URL(string: "https://api.unsplash.com/photos/?client_id=UNITTESTS")!

        Mock(url: originalURL, ignoreQuery: true, dataType: .json, statusCode: 200, data: [
            .get: Data()
            ]).register()

        let dataSource = PhotoDataSource()
        dataSource.urlSession = urlSession
        dataSource.loadPhotoListFromNetwork { (results) in
            guard case .failure(let error as UnsplashError) = results else { return }
            switch error {
            case .emptyData:
                expectation.fulfill()
            default:
                XCTFail("unexpected error: \(error)")
            }
        }

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testLoadPhotoListFromNetwork_invalidJSON_failure() {
        let expectation = self.expectation(description: "loading photos from network.")
        let originalURL = URL(string: "https://api.unsplash.com/photos/?client_id=UNITTESTS")!

        Mock(url: originalURL, ignoreQuery: true, dataType: .json, statusCode: 200, data: [
            .get: MockData.invalidJSON.data
            ]).register()

        let dataSource = PhotoDataSource()
        dataSource.urlSession = urlSession
        dataSource.loadPhotoListFromNetwork { (results) in
            guard case .failure(_ as DecodingError) = results else { return }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0, handler: nil)
    }
}

final class MockData {
    static let validJSON: URL = Bundle(for: MockData.self).url(forResource: "valid_response", withExtension: "json")!
    static let validTwoPhotoJSON: URL = Bundle(for: MockData.self).url(forResource: "valid_two_photos", withExtension: "json")!
    static let serverErrorJSON: URL = Bundle(for: MockData.self).url(forResource: "error_response", withExtension: "json")!
    static let invalidJSON: URL = Bundle(for: MockData.self).url(forResource: "error_invalid_response", withExtension: "json")!
}

private extension URL {
    /// Returns a `Data` representation of the current `URL`. Force unwrapping as it's only used for tests.
    var data: Data {
        //swiftlint:disable:next force_try
        return try! Data(contentsOf: self)
    }
}
