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
        case expectedFailure
        case unknown(String)

        init(from value: String) {
            switch value {
            case "Success": self = .success
            case "Failure": self = .failure
            case "Skipped": self = .skipped
            case "Expected Failure": self = .expectedFailure
            default: self = .unknown(value)
            }
        }
    }
}
