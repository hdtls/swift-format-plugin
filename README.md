# Swift Format Plugin
A swift package manager command plugin for [swift-format](https://github.com/apple/swift-format).

## Getting Started
To use this plugin from other packages, add this plugin as a dependency.
```swift
// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "Example",
    dependencies: [
        ...
        .package(url: "https://github.com/hdtls/swift-format-plugin.git", from: "1.0.0")
    ],
    ...
```

Run this plugin:
```bash
swift package --allow-writing-to-package-directory format-source-code
```

More about [SwiftPM Command Plugins](https://github.com/apple/swift-evolution/blob/main/proposals/0332-swiftpm-command-plugins.md).
