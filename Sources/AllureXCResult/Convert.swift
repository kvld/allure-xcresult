//
//  Convert.swift
//  
//
//  Created by Vladislav Kiryukhin on 22.12.2021.
//

import Foundation
import ArgumentParser
import AllureXCResultLib

struct Convert: ParsableCommand {
    static var configuration = CommandConfiguration(version: "1.1.0")

    @Option(name: .long, help: "Input *.xcresult path")
    var input: String

    @Option(name: .long, help: "Output path")
    var output: String

    @Flag(name: .long, help: "Ignore failed tests")
    var ignoreFailed = false

    @Flag(name: .long, help: "Overwrite output directory")
    var overwrite = false

    func run() throws {
        print("Converting report '\(input)'...")
        print("Directory for result: \(output)")

        let creator = ReportFilesCreator(outputPath: output, overwriteOutput: overwrite)

        ReportConverter.convertOneByOne(xcResultPath: input) { result in
            switch result {
            case .fatalError(let message):
                print("Fatal error occurred!\n\(message)")
                rollbackAlreadyConverted()
                Self.exit(withError: ExitCode.failure)

            case .error(let error):
                print("Unable to convert '\(error.name)' due to \"\(error.message)\"")

                if !ignoreFailed {
                    print("Rollback already converted tests...")
                    rollbackAlreadyConverted()
                    Self.exit(withError: ExitCode.failure)
                } else {
                    print("'\(error.name)' will be skipped!")
                }

            case .success(let report):
                do {
                    try writeToOutput(report: report, creator: creator)
                } catch {
                    print("Error occurred: \(error)")
                    rollbackAlreadyConverted()

                    Self.exit(withError: ExitCode.failure)
                }
            }
        }

        Self.exit(withError: ExitCode.success)
    }

    private func rollbackAlreadyConverted() {
        try? FileManager.default.removeItem(atPath: output)
    }

    private func writeToOutput(report: AllureReport, creator: ReportFilesCreator) throws {
        for test in report.tests {
            try creator.write(test: test)
        }

        for attachment in report.attachments {
            try creator.write(attachment: attachment)
        }
    }
}
