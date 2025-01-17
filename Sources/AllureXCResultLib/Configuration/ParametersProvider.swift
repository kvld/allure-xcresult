//
//  ParametersProvider.swift
//  allure-xcresult
//
//  Created by Dmitry Barillo on 16.01.2025.
//

public protocol ParametersProvider {
    func makeParameters(testCase: TestCase) -> [Parameter]
}

struct DefaultParametersProvider: ParametersProvider {
    func makeParameters(testCase: TestCase) -> [Parameter] {
        []
    }
}
