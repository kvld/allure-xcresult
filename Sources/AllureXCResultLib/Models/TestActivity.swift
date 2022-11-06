//
//  TestActivity.swift
//  
//
//  Created by Vladislav Kiryukhin on 22.12.2021.
//

import Foundation

struct TestActivity {
    let title: String
    let activityType: ActivityType
    let uuid: String
    let startedTime: Date?
    let endedTime: Date?
    let subactivities: [TestActivity]
    let attachments: [TestAttachment]

    enum ActivityType {
        case failure
        case normal
    }
}
