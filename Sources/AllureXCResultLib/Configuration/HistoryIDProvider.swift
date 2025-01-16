//
//  HistoryIDProvider.swift
//  allure-xcresult
//
//  Created by Dmitry Barillo on 16.01.2025.
//

public protocol HistoryIDProvider {
    func makeHistoryID(testCase: TestCase) -> String
}

struct DefaultHistoryIDProvider: HistoryIDProvider {
    func makeHistoryID(testCase: TestCase) -> String {
        let summary = testCase.summary
        return (summary.path.prefix(1) + [summary.identifier]).joined(separator: "/")
    }
}
