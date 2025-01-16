//
//  TestFailure.swift
//
//
//  Created by Vladislav Kiryukhin on 20.10.2022.
//

import Foundation

public struct TestFailure {
    public let uuid: String
    public let message: String?
    public let detailedDescription: String?
    public let issueType: String?
    public let file: SourceFileReference?
    public let timestamp: Date
    public let attachments: [TestAttachment]

    public struct SourceFileReference {
        let absoluteFilePath: String
        let lineNumber: Int

        var fileName: String? {
            URL(string: absoluteFilePath)?.lastPathComponent
        }
    }

    var stepTitle: String {
        // Xcode format
        [
            (issueType as String?).flatMap { "\($0)" },
            file?.fileName.flatMap { " at \($0):\(file?.lineNumber ?? 0): "} ?? ": ",
            message
        ]
        .compactMap { $0 }
        .joined(separator: "")
    }
}

extension TestFailure {
    /// Convert failure to usual activity to show it as step
    func makeActivity() -> TestActivity {
        return TestActivity(
            title: stepTitle,
            activityType: .failure,
            uuid: uuid,
            startedTime: timestamp,
            endedTime: timestamp,
            subactivities: [],
            attachments: attachments
        )
    }
}
