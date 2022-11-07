//
//  StepResult.swift
//  
//
//  Created by Vladislav Kiryukhin on 20.12.2021.
//

import Foundation

// see: https://github.com/allure-framework/allure-java/tree/2.17.2/allure-model/src/main/java/io/qameta/allure/model/StepResult.java
public struct StepResult: Encodable {
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
