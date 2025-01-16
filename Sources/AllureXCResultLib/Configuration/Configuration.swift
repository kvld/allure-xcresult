//
//  Configuration.swift
//  allure-xcresult
//
//  Created by Dmitry Barillo on 16.01.2025.
//

public struct Configuration {
    public let historyIDProvider: any HistoryIDProvider
    public let parametersProvider: any ParametersProvider

    public init(
        historyIDProvider: any HistoryIDProvider,
        parametersProvider: any ParametersProvider
    ) {
        self.historyIDProvider = historyIDProvider
        self.parametersProvider = parametersProvider
    }
}
