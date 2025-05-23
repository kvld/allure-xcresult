//
//  Allure.swift
//  
//
//  Created by Vladislav Kiryukhin on 07.11.2022.
//

import XCTest

/// Helper class to make an opportunity to add Allure labels to XCTest
/// https://github.com/allure-framework/allure2/blob/2.20.0/allure-plugin-api/src/main/java/io/qameta/allure/entity/LabelName.java
public enum Allure {
    public static func owner(_ name: String) {
        labelStep(key: "owner", value: name)
    }

    public static func severity(_ level: SeverityLevel) {
        labelStep(key: "severity", value: level.rawValue)
    }

    public static func issue(_ name: String) {
        labelStep(key: "issue", value: name)
    }

    public static func tag(_ name: String) {
        labelStep(key: "tag", value: name)
    }

    public static func testType(_ type: String) {
        labelStep(key: "testType", value: type)
    }

    public static func parentSuite(_ suite: String) {
        labelStep(key: "parentSuite", value: suite)
    }

    public static func suite(_ suite: String) {
        labelStep(key: "suite", value: suite)
    }

    public static func subSuite(_ suite: String) {
        labelStep(key: "subSuite", value: suite)
    }

    public static func package(_ name: String) {
        labelStep(key: "package", value: name)
    }

    public static func epic(_ name: String) {
        labelStep(key: "epic", value: name)
    }

    public static func feature(_ name: String) {
        labelStep(key: "feature", value: name)
    }

    public static func story(_ name: String) {
        labelStep(key: "story", value: name)
    }

    public static func testClass(_ name: String) {
        labelStep(key: "testClass", value: name)
    }

    public static func testMethod(_ name: String) {
        labelStep(key: "testMethod", value: name)
    }

    public static func host(_ name: String) {
        labelStep(key: "host", value: name)
    }

    public static func thread(_ name: String) {
        labelStep(key: "thread", value: name)
    }

    public static func language(_ name: String) {
        labelStep(key: "language", value: name)
    }

    public static func framework(_ name: String) {
        labelStep(key: "framework", value: name)
    }

    public static func resultFormat(_ format: String) {
        labelStep(key: "resultFormat", value: format)
    }

    public static func label(key: String, value: String) {
        labelStep(key: key, value: value)
    }
}

extension Allure {
    fileprivate static func labelStep(key labelName: String, value: String) {
        XCTContext.empty(with: "allure_label_\(labelName)_\(value)")
    }
}

extension XCTContext {
    static func empty(with name: String) {
        XCTContext.runActivity(named: name, block: { _ in })
    }
}
