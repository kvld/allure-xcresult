//
//  ReportFilesCreator.swift
//  
//
//  Created by Vladislav Kiryukhin on 22.12.2021.
//

import Foundation

public final class ReportFilesCreator {
    private let outputPath: String
    private let overwriteOutput: Bool
    private let encoder: JSONEncoder
    private let fileManager: FileManager

    private var shouldCheckOutputDirectory = true

    private lazy var outputURL = URL(fileURLWithPath: outputPath)

    public init(outputPath: String, overwriteOutput: Bool) {
        self.outputPath = outputPath
        self.overwriteOutput = overwriteOutput

        self.fileManager = FileManager.default

        let encoder = JSONEncoder()
        self.encoder = encoder
    }

    public func write(test: TestResult) throws {
        if shouldCheckOutputDirectory {
            try createOutputDirectoryIfNeeded()
            shouldCheckOutputDirectory = false
        }

        let filename = "\(test.uuid)-result.json"
        let fullURL = outputURL.appendingPathComponent(filename)

        do {
            let data = try encoder.encode(test)

            fileManager.createFile(atPath: fullURL.path, contents: nil, attributes: nil)
            try data.write(to: fullURL, options: .atomic)
        } catch {
            throw ConverterError.unableToWriteOutput(reason: error.localizedDescription)
        }
    }

    public func write(attachment: LazyAttachment) throws {
        let attachment = attachment()
        let filename = attachment.name

        guard let url = attachment.exportedFileURL else { return }

        if shouldCheckOutputDirectory {
            try createOutputDirectoryIfNeeded()
            shouldCheckOutputDirectory = false
        }

        let fullURL = outputURL.appendingPathComponent(filename)

        do {
            if fileManager.fileExists(atPath: fullURL.path) {
                print("File '\(fullURL.path)' already exists, overwrite it")
                try fileManager.removeItem(at: fullURL)
            }

            try fileManager.moveItem(at: url, to: fullURL)
        } catch {
            throw ConverterError.unableToWriteOutput(reason: error.localizedDescription)
        }
    }

    private func createOutputDirectoryIfNeeded() throws {
        if !overwriteOutput, fileManager.fileExists(atPath: outputPath) {
            throw ConverterError.outputDirectoryExists
        }

        if overwriteOutput {
            try? fileManager.removeItem(atPath: outputPath)
        }

        do {
            try fileManager.createDirectory(atPath: outputPath, withIntermediateDirectories: false, attributes: nil)
        } catch {
            throw ConverterError.unableToWriteOutput(reason: error.localizedDescription)
        }

        if !fileManager.isWritableFile(atPath: outputPath) {
            throw ConverterError.unableToWriteOutput(reason: "Output path isn't writable")
        }
    }
}
