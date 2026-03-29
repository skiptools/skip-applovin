// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0

import XCTest
import OSLog
import Foundation
@testable import SkipAppLovin

let logger: Logger = Logger(subsystem: "SkipAppLovin", category: "Tests")

@available(macOS 13, *)
final class SkipAppLovinTests: XCTestCase {

    func testSkipAppLovin() throws {
        logger.log("running testSkipAppLovin")
        XCTAssertEqual(1 + 2, 3, "basic test")
    }

    func testDecodeType() throws {
        // load the TestData.json file from the Resources folder and decode it into a struct
        let resourceURL: URL = try XCTUnwrap(Bundle.module.url(forResource: "TestData", withExtension: "json"))
        let testData = try JSONDecoder().decode(TestData.self, from: Data(contentsOf: resourceURL))
        XCTAssertEqual("SkipAppLovin", testData.testModuleName)
    }

}

struct TestData : Codable, Hashable {
    var testModuleName: String
}
