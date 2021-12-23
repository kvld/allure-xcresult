//
//  XCResultExtractor.swift
//
//
//  Created by Vladislav Kiryukhin on 22.12.2021.
//

import XCResultKit
import Foundation

enum XCResultExtractor {
    static func extract(from filePath: String, handler: @escaping (TestCase) -> Void) throws {
        let result = XCResultFile(url: URL(fileURLWithPath: filePath))

        guard let invocation = result.getInvocationRecord() else {
            throw ExtractionError.noInvocationFound
        }

        var testRuns: [TestRun] = []

        for action in invocation.actions {
            guard let testsRef = action.actionResult.testsRef else { continue }

            let destinationInfo = DestinationInfo(
                identifier: action.runDestination.localComputerRecord.identifier,
                name: action.runDestination.displayName
            )

            let startedTime = action.startedTime
            let endedTime = action.endedTime

            let testRun = TestRun(
                id: testsRef.id,
                startedTime: startedTime,
                endedTime: endedTime,
                destinationInfo: destinationInfo
            )
            testRuns.append(testRun)
        }

        for testRun in testRuns {
            guard let testPlanSummary = result.getTestPlanRunSummaries(id: testRun.id) else { continue }

            let testsSummary = testPlanSummary.summaries
                .flatMap(\.testableSummaries)
                .flatMap(\.tests)
                .flatMap { $0.extractTests() }

            autoreleasepool {
                for testSummary in testsSummary {
                    var activities: [TestActivity] = []

                    if let summaryID = testSummary.summaryID,
                       let actionTestSummary = result.getActionTestSummary(id: summaryID) {
                        activities = actionTestSummary.activitySummaries.map { $0.extractActivity() }
                    }

                    let attachments = activities
                        .flatMap { $0.getAllAttachments() }
                        .map { attachment -> LazyAttachment in
                            return {
                                AttachmentExportInfo(
                                    name: attachment.filename,
                                    exportedFileURL: result.exportPayload(id: attachment.payloadRefID)
                                )
                            }
                        }

                    let testCase = TestCase(
                        summary: testSummary,
                        activities: activities,
                        destination: testRun.destinationInfo,
                        testRun: testRun,
                        attachments: attachments
                    )

                    handler(testCase)
                }
            }
        }
    }

    enum ExtractionError: Error {
        case noInvocationFound
    }
}

private extension ActionTestSummaryGroup {
    private func _extractTests(path: [String]) -> [TestSummary] {
        var summaries: [TestSummary] = []

        for group in subtestGroups {
            summaries.append(contentsOf: group._extractTests(path: path + [name ?? "Default"]))
        }

        for test in subtests {
            let test = TestSummary(
                identifier: test.identifier,
                name: test.name,
                path: path,
                status: .init(from: test.testStatus),
                duration: test.duration ?? 0.0,
                summaryID: test.summaryRef?.id
            )

            summaries.append(test)
        }

        return summaries
    }

    func extractTests() -> [TestSummary] {
        return _extractTests(path: [])
    }
}

private extension ActionTestActivitySummary {
    func extractActivity() -> TestActivity {
        let attachments: [TestActivity.Attachment] = attachments.compactMap { attachment in
            guard let filename = attachment.filename, let payloadRefID = attachment.payloadRef?.id else { return nil }

            return .init(name: filename, filename: filename, payloadRefID: payloadRefID)
        }

        return TestActivity(
            title: title,
            activityType: activityType,
            uuid: uuid,
            startedTime: start,
            endedTime: finish,
            subactivities: subactivities.map { $0.extractActivity() },
            attachments: attachments
        )
    }
}

private extension TestActivity {
    func getAllAttachments() -> [Attachment] {
        subactivities.flatMap { $0.getAllAttachments() } + attachments
    }
}
