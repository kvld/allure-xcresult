//
//  Status.swift
//  
//
//  Created by Vladislav Kiryukhin on 20.12.2021.
//

import Foundation

// see: https://github.com/allure-framework/allure-java/tree/2.17.2/allure-model/src/main/java/io/qameta/allure/model/Status.java
public enum Status: String, Encodable {
    case failed
    case broken
    case passed
    case skipped
}
