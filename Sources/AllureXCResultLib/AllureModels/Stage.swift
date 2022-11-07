//
//  Stage.swift
//  
//
//  Created by Vladislav Kiryukhin on 20.12.2021.
//

import Foundation

// see: https://github.com/allure-framework/allure-java/tree/2.17.2/allure-model/src/main/java/io/qameta/allure/model/Stage.java
public enum Stage: String, Encodable {
    case scheduled
    case running
    case finished
    case pending
    case interrupted
}
