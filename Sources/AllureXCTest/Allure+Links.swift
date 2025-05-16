//
//  Allure+Links.swift
//
//
//  Created by Miguel Franco on 14.05.2025.
//

import XCTest

/// Helper class to make an opportunity to add Allure links to XCTest
/// https://github.com/allure-framework/allure2/blob/2.20.0/allure-plugin-api/src/main/java/io/qameta/allure/entity/Link.java
extension Allure {
    public static func link(
        name: String,
        type: LinkType,
        url: String
    ) {
        linkStep(
            name: name,
            type: type,
            url: url
        )
    }
}

extension Allure {
    fileprivate static func linkStep(
        name: String,
        type: LinkType,
        url: String,
        linkPattern:String = "https://"
    ) {
        let finalURL = url.hasPrefix(linkPattern) ? url : "\(linkPattern)\(url)"
        XCTContext.empty(with: "allure_link_\(name)_\(type.rawValue)_\(finalURL)")
    }
}
