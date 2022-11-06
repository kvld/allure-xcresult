# allure-xcresult

A tool for converting Xcode-produced `*.xcresult` to format for [Allure](https://docs.qameta.io/allure-report/).

## Usage

There are two ways of usage: a CLI tool or an SPM package to integrate the converting step in your pipeline.

### CLI

Download the binary from [Releases](https://github.com/kvld/allure-xcresult/releases) page and make it executable (`chmod +x 
allure-xcresult`).
Also, you can build it from sources: just clone this repo and run `swift build`.

Run:
```bash
allure-xcresult --input /path/to/file.xcresult --output /path/to/output_directory
```

### SPM

1. Add dependency to Package.swift:
```swift
.package(url: "https://github.com/kvld/allure-xcresult.git", from: "1.0.0")
```
2. Add product dependency to the target:
```swift
.product(name: "AllureXCResultLib", package: "allure-xcresult")
```
3. In your code:
```swift
import AllureXCResultLib

let inputPath = "/path/to/input.xcresult"
let outputPath = "/path/to/output_directory"

// You will need a creator to write json with data or attachments on the disk
let filesCreator = ReportFilesCreator(outputPath: outputPath, overwriteOutput: false)

// Also you can execute `ReportConverter.convertOneByOne(xcResultPath:handler:)` if you need to handle tests separately
let result = ReportConverter.convert(xcResultPath: inputPath)

if case let .success(report) = result {
    report.tests.forEach { try? filesCreator.write(test: $0) }
    report.attachments.forEach { try? filesCreator.write(attachment: $0) }
}
```
