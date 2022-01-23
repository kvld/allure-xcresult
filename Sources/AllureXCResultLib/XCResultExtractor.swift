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
                identifier: action.runDestination.targetDeviceRecord.identifier,
                name: action.runDestination.targetDeviceRecord.name,
                machineIdentifier: action.runDestination.localComputerRecord.identifier
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

            var testsSummaries: [TestSummary] = []
            let testableSummaries = testPlanSummary.summaries.flatMap(\.testableSummaries)
            for summary in testableSummaries {
                let targetName = summary.targetName ?? "Default"
                let tests = summary.tests.flatMap { $0.extractTests(targetName: targetName) }

                testsSummaries.append(contentsOf: tests)
            }

            autoreleasepool {
                for testSummary in testsSummaries {
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

    func extractTests(targetName: String) -> [TestSummary] {
        return _extractTests(path: [targetName])
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
