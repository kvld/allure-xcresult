//
//  TestSummary.swift
//  
//
//  Created by Vladislav Kiryukhin on 22.12.2021.
//

import Foundation

public struct TestSummary {
    public let identifier: String
    public let name: String
    public let path: [String]
    public let status: Status
    public let duration: TimeInterval
    public let summaryID: String?

    public enum Status {
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
