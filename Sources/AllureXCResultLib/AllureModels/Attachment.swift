//
//  Attachment.swift
//  
//
//  Created by Vladislav Kiryukhin on 20.12.2021.
//

import Foundation

// see: https://github.com/allure-framework/allure-java/tree/2.17.2/allure-model/src/main/java/io/qameta/allure/model/Attachment.java
public struct Attachment: Encodable {
    public let name: String
    public let source: String
    public let type: String?
}
