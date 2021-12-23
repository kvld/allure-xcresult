//
//  TestActivity.swift
//  
//
//  Created by Vladislav Kiryukhin on 22.12.2021.
//

import Foundation

struct TestActivity {
    let title: String
    let activityType: String
    let uuid: String
    let startedTime: Date?
    let endedTime: Date?
    let subactivities: [TestActivity]
    let attachments: [Attachment]

    struct Attachment {
        let name: String
        let filename: String
        let payloadRefID: String
    }
}
