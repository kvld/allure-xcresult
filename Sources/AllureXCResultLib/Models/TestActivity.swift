//
//  TestActivity.swift
//  
//
//  Created by Vladislav Kiryukhin on 22.12.2021.
//

import Foundation

public struct TestActivity {
    public let title: String
    public let activityType: ActivityType
    public let uuid: String
    public let startedTime: Date?
    public let endedTime: Date?
    public let subactivities: [TestActivity]
    public let attachments: [TestAttachment]

    public enum ActivityType {
        case failure
        case normal
    }
}
