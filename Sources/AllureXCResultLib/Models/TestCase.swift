//
//  TestCase.swift
//  
//
//  Created by Vladislav Kiryukhin on 22.12.2021.
//

import Foundation

public struct TestCase {
    public let summary: TestSummary
    public let activities: [TestActivity]
    public let destination: DestinationInfo
    public let testRun: TestRun
    public let attachments: [LazyAttachment]
}
