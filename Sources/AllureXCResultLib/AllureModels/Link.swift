//
//  Link.swift
//  
//
//  Created by Vladislav Kiryukhin on 20.12.2021.
//

import Foundation

// see: https://github.com/allure-framework/allure-java/blob/master/allure-model/src/main/java/io/qameta/allure/model/Link.java
public struct Link: Encodable {
    public let name: String
    public let url: String
    public let type: String
}
