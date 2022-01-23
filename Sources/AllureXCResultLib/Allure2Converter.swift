//
//  Allure2Converter.swift
//  
//
//  Created by Vladislav Kiryukhin on 21.12.2021.
//

import Foundation

enum Allure2Converter {
    static func convert(testCase: TestCase) throws -> (test: TestResult, attachments: [LazyAttachment]) {
        let uuid = UUID().uuidString.lowercased()

        let steps = testCase.activities.map { Self.makeStep(from: $0) }

        let minStart = steps.compactMap { $0.start > 0 ? $0.start : nil }.min()
        let maxStop = steps.compactMap { $0.stop > 0 ? $0.stop : nil }.max()

        let startTime = minStart ?? testCase.testRun.startedTime.millis
        let stopTime = maxStop ?? (startTime + testCase.summary.duration.millis)

        let statusDetails = steps.first(where: { $0.statusDetails != nil })?.statusDetails

        do {
            let test = try TestResult(
                uuid: uuid,
                historyId: Self.makeHistoryID(for: testCase.summary),
                testCaseId: nil,
                testCaseName: nil,
                fullName: testCase.summary.identifier,
                labels: Self.makeLabels(for: testCase),
                links: [],
                name: testCase.summary.name,
                status: Self.makeStatus(for: testCase.summary),
                statusDetails: statusDetails,
                stage: nil,
                description: nil,
                descriptionHtml: nil,
                steps: steps,
                attachments: [],
                parameters: [],
                start: startTime,
                stop: stopTime
            )

            let attachments: [LazyAttachment] = testCase.attachments

            return (test, attachments)
        } catch ConvertationError.unknownStatus(let msg) {
            throw ConverterError.invalidTestCase(message: msg, name: testCase.summary.name)
        }
    }
}

extension Allure2Converter {
    private static func makeStatus(for summary: TestSummary) throws -> Status {
        switch summary.status {
        case .success: return .passed
        case .failure: return .failed
        case .skipped: return .skipped
        case .unknown(let value):
            throw ConvertationError.unknownStatus("Unknown status for '\(value)'")
        }
    }

    private static func makeHistoryID(for summary: TestSummary) -> String {
        return (summary.path.prefix(1) + [summary.identifier]).joined(separator: "/")
    }

    private static func makeAttachment(from attachment: TestActivity.Attachment) -> Attachment {
        Attachment(name: attachment.name, source: attachment.name, type: nil)
    }

    private static func makeStep(from activity: TestActivity) -> StepResult {
        let substeps = activity.subactivities.map { Self.makeStep(from: $0) }
        let attachments = activity.attachments.map { Self.makeAttachment(from: $0) }

        let status: Status
        let statusDetails: StatusDetails?

        if let firstFailedSubstep = substeps.first(where: { $0.status == .failed }) {
            status = firstFailedSubstep.status
            statusDetails = firstFailedSubstep.statusDetails
        } else {
            status = activity.activityType == "com.apple.dt.xctest.activity-type.testAssertionFailure"
                ? .failed
                : .passed

            statusDetails = status == .failed
                ? StatusDetails(known: false, muted: false, flaky: false, message: activity.title, trace: "")
                : nil
        }

        return StepResult(
            name: activity.title,
            status: status,
            statusDetails: statusDetails,
            stage: nil,
            description: nil,
            descriptionHtml: nil,
            steps: substeps,
            attachments: attachments,
            parameters: [],
            start: activity.startedTime?.millis ?? 0,
            stop: activity.endedTime?.millis ?? activity.startedTime?.millis ?? 0
        )
    }

    private static func makeLabels(for testCase: TestCase) -> [Label] {
        var labels: [Label] = []

        if let parentSuite = testCase.summary.path.first {
            labels.append(Label(name: "parentSuite", value: parentSuite))
        }

        if let suite = testCase.summary.identifier.split(separator: "/").first {
            labels.append(Label(name: "suite", value: String(suite)))
        }

        let hostValue = "\(testCase.destination.name) (\(testCase.destination.identifier))"
            + " on \(testCase.destination.machineIdentifier)"

        labels.append(
            Label(name: "host", value: hostValue)
        )

        return labels
    }
}

extension Allure2Converter {
    enum ConvertationError: Error {
        case unknownStatus(String)
    }
}

private extension Date {
    var millis: Int { Int(timeIntervalSince1970 * 1000) }
}

private extension TimeInterval {
    var millis: Int { Int(self * 1000) }
}
