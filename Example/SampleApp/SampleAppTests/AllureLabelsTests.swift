//
//  AllureLabelsTests.swift
//  SampleAppTests
//
//  Created by Vladislav Kiryukhin on 07.11.2022.
//

import XCTest
import AllureXCTest

final class AllureLabelsTests: XCTestCase {
    func testSeverity() {
        Allure.severity(.critical)

        XCTAssert(2 + 2 == 4, "Critical test is OK!")
    }

    func testFeature() {
        Allure.feature("Allure labels")

        XCTFail()
    }

    func testTags() {
        Allure.tag("tag one")
        Allure.tag("tag two")
        Allure.tag("tag three")

        XCTFail()
    }
}
