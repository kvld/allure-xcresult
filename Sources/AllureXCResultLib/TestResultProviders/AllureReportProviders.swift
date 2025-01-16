//
//  AllureReportProviders.swift
//  allure-xcresult
//
//  Created by Dmitry Barillo on 16.01.2025.
//

public protocol AllureReportProviders {
    var historyIDProvider: HistoryIDProvider { get }
    var parametersProvider: ParametersProvider { get }
}

public struct ReportConverterProviders: AllureReportProviders {
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
