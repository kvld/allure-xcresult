//
//  SampleAppTests.swift
//  SampleAppTests
//
//  Created by Vladislav Kiryukhin on 06.11.2022.
//

import XCTest

final class SampleAppTests: XCTestCase {
    func testSucceeded() {
        XCTAssertTrue(true, "Dummy assert with true value")
    }

    func testFailed() {
        XCTAssertTrue(false, "Dummy assert with false value")
    }

    func testSkipped() throws {
        throw XCTSkip("Test skipped because of smth")
    }

    func testWithSubsteps() {
        XCTContext.runActivity(named: "Substep") { _ in
            XCTContext.runActivity(named: "Subsubstep") { _ in
                XCTFail()
            }
        }
    }

    func testWithAttachment() {
        XCTContext.runActivity(named: "Attachment step") { activity in
            let attachment = XCTAttachment(string: "Test attachment content")
            activity.add(attachment)

            XCTFail()
        }
    }
}
