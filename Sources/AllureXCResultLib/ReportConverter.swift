//
//  ReportConverter.swift
//  
//
//  Created by Vladislav Kiryukhin on 22.12.2021.
//

import Foundation

public struct TestConvertionError {
    public let message: String
    public let name: String
}

public struct AttachmentExportInfo {
    public let name: String
    public let exportedFileURL: URL?
}

public typealias LazyAttachment = () -> AttachmentExportInfo

public struct AllureReport {
    public let tests: [TestResult]
    public let attachments: [LazyAttachment]
}

public enum StreamResult {
    case fatalError(message: String)
    case error(TestConvertionError)
    case success(AllureReport)
}

public enum Result {
    case fatalError(message: String)
    case nonFatalError(report: AllureReport, errors: [TestConvertionError])
    case success(AllureReport)
}

public enum ReportConverter {
    /// Return each converted test separately.
    /// Operation will be stopped if `StreamResult.fatalError` returned in handler.
    public static func convertOneByOne(xcResultPath: String, handler: @escaping (StreamResult) -> Void) {
        do {
            try XCResultExtractor.extract(from: xcResultPath) { testCase in
                do {
                    let convertedTest = try Allure2Converter.convert(testCase: testCase)

                    let result = AllureReport(
                        tests: [convertedTest.test],
                        attachments: convertedTest.attachments
                    )

                    handler(.success(result))
                } catch {
                    if let error = error as? ConverterError, case let .invalidTestCase(message, name) = error {
                        handler(.error(.init(message: message, name: name)))
                    } else {
                        handler(.fatalError(message: error.localizedDescription))
                        return
                    }
                }
            }
        } catch ConverterError.noInvocationFound {
            handler(.fatalError(message: "No invocation found in xcresult file"))
            return
        } catch {
            handler(.fatalError(message: error.localizedDescription))
            return
        }
    }

    /// Wait until all tests will be converted and return the final result.
    public static func convert(xcResultPath: String) -> Result {
        var tests: [TestResult] = []
        var attachments: [LazyAttachment] = []
        var errors: [TestConvertionError] = []

        var ocurredFatalError: String?

        convertOneByOne(xcResultPath: xcResultPath) { result in
            switch result {
            case .fatalError(let message):
                ocurredFatalError = message

            case .error(let testConvertionError):
                errors.append(testConvertionError)

            case .success(let allureReport):
                tests.append(contentsOf: allureReport.tests)
                attachments.append(contentsOf: allureReport.attachments)
            }
        }

        if let ocurredFatalError = ocurredFatalError {
            return .fatalError(message: ocurredFatalError)
        }

        let report = AllureReport(tests: tests, attachments: attachments)

        return !errors.isEmpty ? .nonFatalError(report: report, errors: errors) : .success(report)
    }
}
