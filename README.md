<!-- markdownlint-disable MD033 MD041 -->
<div align="center">

# SimpleLoggerUI

![Swift Versions](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmarkbattistella%2FSimpleLoggerUI%2Fbadge%3Ftype%3Dswift-versions)

![Platforms](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmarkbattistella%2FSimpleLoggerUI%2Fbadge%3Ftype%3Dplatforms)

![Licence](https://img.shields.io/badge/Licence-MIT-white?labelColor=blue&style=flat)

</div>

`SimpleLoggerUI` is a Swift package that provides a complete, ready-to-use SwiftUI interface for inspecting logs collected via the [`SimpleLogger`](https://github.com/markbattistella/SimpleLogger) package.

It includes a full log list screen with filtering, exporting, and platform-appropriate UI behaviour for iOS, macOS, iPadOS, and visionOS—without requiring you to build or manage any custom logging UI.

## Features

- **Log list screen**
  - Displays logs with timestamp, level, subsystem, category, and message
  - Visual styling adapts to log severity for improved scan-ability
  - Pull-to-refresh support

- **Filtering**
  - Exclude system logs
  - Filter by:
    - Specific date
    - Date range
    - Hour range (within a single day)
    - Preset ranges (e.g. recent periods)
  - Filter by log level with multi-selection support

- **Exporting**
  - Export formats:
    - Plain log
    - JSON
    - JSON Lines
    - CSV (configurable delimiter)
  - Optional gzip compression for file exports
  - Export to file system or copy directly to clipboard

- **Cross-platform**
  - Adaptive navigation and toolbar behaviour
  - Native file exporter integration
  - macOS and iOS-appropriate interaction patterns

## Installation

Add `SimpleLoggerUI` using Swift Package Manager.

```swift
dependencies: [
  .package(
    url: "https://github.com/markbattistella/SimpleLoggerUI", 
    from: "1.0.0"
  )
]
```

Alternatively, you can add `SimpleLoggerUI` using Xcode by navigating to `File > Add Packages` and entering the package repository URL.

## Usage

### LogListScreen

`LogListScreen` is the primary entry point. It manages fetching, filtering, and exporting logs internally using `LoggerManager`.

> ![IMPORTANT]
> You do not need to supply logs manually.

```swift
import SwiftUI
import SimpleLoggerUI

struct ContentView: View {
  var body: some View {
    NavigationStack {
      LogListScreen()
    }
  }
}
```

LogListScreen automatically:

- Fetches logs on appearance
- Supports pull-to-refresh
- Provides toolbar actions for filtering and exporting
- Displays loading and empty states

## Filtering Logs

Tap Filter in the toolbar to open the filter sheet.

Available filter modes:

### Specific date

View logs recorded on a single calendar day.

### Date range

View logs across multiple days (inclusive).

### Hour range

Select a date and restrict logs to a specific hour window.

### Preset

Quickly apply commonly used time ranges.

You can also:

- Exclude system logs
- Select which log levels are visible
- Filter changes are applied immediately.

## Exporting Logs

Tap Export in the toolbar to open the export sheet.

### Export options

- Output formats:
  - `.log`
  - `.json`
  - `.jsonl`
  - `.csv`
- CSV delimiter selection
- Optional gzip compression (file exports only)

### Export destinations

- **Export to file:** Saves the export via the system file picker.
- **Copy to clipboard:** Copies UTF-8 text in the selected format (compression ignored).

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request for any features, fixes, or improvements.

## License

`SimpleLoggerUI` is available under the MIT license. See the LICENCE file for more information.
