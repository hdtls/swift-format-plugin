//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift Logging API open source project
//
// Copyright (c) 2022 Junfeng Zhang and the Swift Format Plugin project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import PackagePlugin
import Foundation

@main
struct FormatPlugin: CommandPlugin {

    func performCommand(context: PluginContext, arguments: [String]) async throws {
        // We'll be invoking `swift-format`, so start by locating it.
        let swiftFormatTool = try context.tool(named: "swift-format")

        // By convention, use a configuration file in the package directory.
        var configFile = context.package.directory.appending(".swift-format")
        var hasConfigFile = FileManager.default.fileExists(atPath: configFile.string)
        if !hasConfigFile {
            configFile = context.package.directory.appending(".swift-format.json")
            hasConfigFile = FileManager.default.fileExists(atPath: configFile.string)
        }

        // Iterate over the targets in the package.
        for target in context.package.targets {
            // Skip any type of target that doesn't have source files.
            // Note: We could choose to instead emit a warning or error here.
            guard let target = target as? SourceModuleTarget else { continue }

            // Invoke `swift-format` on the target directory, passing a configuration
            // file from the package directory.
            let swiftFormatExec = URL(fileURLWithPath: swiftFormatTool.path.string)

            var swiftFormatArgs: [String] = []
            if hasConfigFile {
                swiftFormatArgs += ["--configuration", "\(configFile)"]
            }
            swiftFormatArgs += [
                "--in-place",
                "--recursive",
                "\(target.directory)"
            ]
            
            let process = try Process.run(swiftFormatExec, arguments: swiftFormatArgs)
            process.waitUntilExit()

            // Check whether the subprocess invocation was successful.
            if process.terminationReason == .exit && process.terminationStatus == 0 {
                print("Formatted the source code in \(target.directory).")
            }
            else {
                let problem = "\(process.terminationReason):\(process.terminationStatus)"
                Diagnostics.error("swift-format invocation failed: \(problem)")
            }
        }
    }
}
