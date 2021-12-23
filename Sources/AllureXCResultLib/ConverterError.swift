//
//  ConverterError.swift
//  
//
//  Created by Vladislav Kiryukhin on 22.12.2021.
//

import Foundation

enum ConverterError: Error {
    case noInvocationFound
    case invalidTestCase(message: String, name: String)
    case outputDirectoryExists
    case unableToWriteOutput(reason: String)
}
