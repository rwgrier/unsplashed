//
//  PhotoDataSourceTests.swift
//  UnsplashTests
//
//  Created by Ryan Grier on 5/6/18.
//  Copyright © 2018 Ryan Grier. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import Unsplash

class PhotoDataSourceTests: XCTestCase {
    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
}

// MARK: - Cached Photo Test

extension PhotoDataSourceTests {
    func testLoadPhotoListFromNetwork_cachedValues_passing() {
        stubResponse(fileNamed: "valid_response.json", statusCode: 200)
        let expectation = self.expectation(description: "loading photos from network.")
        let dataSource = PhotoDataSource()

        dataSource.loadPhotoListFromNetwork { (results) in
            XCTAssertTrue(results.isSuccess)
            guard results.isSuccess else { return }

            let photoCount = dataSource.cachedPhotos.count
            XCTAssertEqual(1, photoCount)

            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0) { (error: Error?) -> Void in
            if error != nil { XCTFail("loadPhotoListFromNetwork failed") }
        }
    }
}

// MARK: - Network Tests

extension PhotoDataSourceTests {
    func testLoadPhotoListFromNetwork_validData_passing() {
        stubResponse(fileNamed: "valid_response.json", statusCode: 200)
        let expectation = self.expectation(description: "loading photos from network.")
        let dataSource = PhotoDataSource()

        dataSource.loadPhotoListFromNetwork { (results) in
            XCTAssertTrue(results.isSuccess)
            guard results.isSuccess else { return }
            let photoCount = results.value?.count ?? 0
            XCTAssertEqual(1, photoCount)

            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0) { (error: Error?) -> Void in
            if error != nil { XCTFail("loadPhotoListFromNetwork failed") }
        }
    }

    func testLoadPhotoListFromNetwork_validDataMultiplePhotos_passing() {
        stubResponse(fileNamed: "valid_two_photos.json", statusCode: 200)
        let expectation = self.expectation(description: "loading photos from network.")
        let dataSource = PhotoDataSource()

        dataSource.loadPhotoListFromNetwork { (results) in
            XCTAssertTrue(results.isSuccess)
            guard results.isSuccess else { return }
            let photoCount = results.value?.count ?? 0
            XCTAssertEqual(2, photoCount)

            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0) { (error: Error?) -> Void in
            if error != nil { XCTFail("loadPhotoListFromNetwork failed") }
        }
    }

    func testLoadPhotoListFromNetwork_serverError_failure() {
        stubResponse(fileNamed: "error_response.json", statusCode: 500)

        let expectation = self.expectation(description: "loading photos from network.")
        let dataSource = PhotoDataSource()
        dataSource.loadPhotoListFromNetwork { (results) in
            XCTAssertTrue(results.isFailure)
            guard results.isFailure, let error = results.error as? UnsplashError else { return }
            switch error {
            case .badHTTPResponse(statusCode: 500):
                expectation.fulfill()
            default:
                XCTFail("unexpected error: \(error)")
            }
        }

        waitForExpectations(timeout: 1.0) { (error: Error?) -> Void in
            if error != nil { XCTFail("loadPhotoListFromNetwork failed") }
        }
    }

    func testLoadPhotoListFromNetwork_emptyData_failure() {
        stub(condition: isHost("api.unsplash.com")) { (_) -> OHHTTPStubsResponse in
            return OHHTTPStubsResponse(
                data: Data(),
                statusCode: 200,
                headers: ["Content-Type": "application/json"])
        }

        let expectation = self.expectation(description: "loading photos from network.")
        let dataSource = PhotoDataSource()
        dataSource.loadPhotoListFromNetwork { (results) in
            XCTAssertTrue(results.isFailure)
            guard results.isFailure, let error = results.error as? UnsplashError else { return }
            switch error {
            case .emptyData:
                expectation.fulfill()
            default:
                XCTFail("unexpected error: \(error)")
            }
        }

        waitForExpectations(timeout: 1.0) { (error: Error?) -> Void in
            if error != nil { XCTFail("loadPhotoListFromNetwork failed") }
        }
    }

    func testLoadPhotoListFromNetwork_invalidJSON_failure() {
        stubResponse(fileNamed: "error_invalid_response.json", statusCode: 200)

        let expectation = self.expectation(description: "loading photos from network.")
        let dataSource = PhotoDataSource()
        dataSource.loadPhotoListFromNetwork { (results) in
            XCTAssertTrue(results.isFailure)
            guard results.isFailure, (results.error as? DecodingError) != nil else { return }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0) { (error: Error?) -> Void in
            if error != nil { XCTFail("loadPhotoListFromNetwork failed") }
        }
    }

    private func stubResponse(fileNamed name: String, statusCode: Int32) {
        stub(condition: isHost("api.unsplash.com")) { (_) -> OHHTTPStubsResponse in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile(name, type(of: self))!,
                statusCode: statusCode,
                headers: ["Content-Type": "application/json"]
            )
        }
    }
}
