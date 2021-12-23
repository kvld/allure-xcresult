//
//  TestCase.swift
//  
//
//  Created by Vladislav Kiryukhin on 22.12.2021.
//

import Foundation

struct TestCase {
    let summary: TestSummary
    let activities: [TestActivity]
    let destination: DestinationInfo
    let testRun: TestRun
    let attachments: [LazyAttachment]
}
