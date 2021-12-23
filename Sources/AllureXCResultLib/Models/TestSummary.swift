//
//  TestSummary.swift
//  
//
//  Created by Vladislav Kiryukhin on 22.12.2021.
//

import Foundation

struct TestSummary {
    let identifier: String
    let name: String
    let path: [String]
    let status: Status
    let duration: TimeInterval
    let summaryID: String?

    enum Status {
        case success
        case failure
        case skipped
        case unknown(String)

        init(from value: String) {
            switch value {
            case "Success": self = .success
            case "Failure": self = .failure
            case "Skipped": self = .skipped
            default: self = .unknown(value)
            }
        }
    }
}
