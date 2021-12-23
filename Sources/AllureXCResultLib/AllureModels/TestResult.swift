//
//  TestResult.swift
//  
//
//  Created by Vladislav Kiryukhin on 20.12.2021.
//

import Foundation

// see: https://github.com/allure-framework/allure-java/blob/master/allure-model/src/main/java/io/qameta/allure/model/TestResult.java
public struct TestResult: Encodable {
    public let uuid: String
    public let historyId: String
    public let testCaseId: String?
    public let testCaseName: String?
    public let fullName: String
    public let labels: [Label]
    public let links: [Link]
    public let name: String
    public let status: Status
    public let statusDetails: StatusDetails?
    public let stage: Stage?
    public let description: String?
    public let descriptionHtml: String?
    public let steps: [StepResult]
    public let attachments: [Attachment]
    public let parameters: [Parameter]
    public let start: Int
    public let stop: Int
}
