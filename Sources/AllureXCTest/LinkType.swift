//
//  LinkType.swift
//
//
//  Created by Miguel Franco on 14.05.2025.
//

import Foundation

public enum LinkType {
    case tms
    case issue
    case custom(String?)
}

extension LinkType: RawRepresentable {
    public typealias RawValue = String
    public var rawValue: String {
        switch self {
        case .tms:
            return "tms"
        case .issue:
            return "issue"
        case .custom(let value):
            return value ?? "custom"
        }
    }

    public init(rawValue: String) {
        switch rawValue {
        case "tms":
            self = .tms
        case "issue":
            self = .issue
        default:
            self = .custom(rawValue)
        }
    }
}
