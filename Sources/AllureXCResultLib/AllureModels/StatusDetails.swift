//
//  StatusDetails.swift
//  
//
//  Created by Vladislav Kiryukhin on 20.12.2021.
//

import Foundation

// see: https://github.com/allure-framework/allure-java/tree/2.17.2/allure-model/src/main/java/io/qameta/allure/model/StatusDetails.java
public struct StatusDetails: Encodable {
    public let known: Bool
    public let muted: Bool
    public let flaky: Bool
    public let message: String
    public let trace: String
}
