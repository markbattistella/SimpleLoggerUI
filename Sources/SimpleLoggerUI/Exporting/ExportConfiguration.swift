//
// Project: SimpleLoggerUI
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SimpleLogger

/// Resolves export options into concrete `SimpleLogger` export formats.
internal struct ExportConfiguration {

  /// The selected base export format.
  var baseFormat: Export.Kind = .log

  /// The delimiter used when the base export format is CSV.
  var csvDelimiter: Export.Delimiter = .comma

  /// Whether file exports should be wrapped in gzip compression.
  var useGzip: Bool = false

  /// The uncompressed base format selected by the user.
  var baseExportFormat: Export.Format {
    switch baseFormat {
    case .log:
      .log
    case .json:
      .json
    case .jsonLines:
      .jsonLines
    case .csv:
      .csv(csvDelimiter)
    }
  }

  /// The format used for file exports.
  var fileExportFormat: Export.Format {
    useGzip ? .gzip(baseExportFormat) : baseExportFormat
  }

  /// The format used for clipboard exports.
  ///
  /// Clipboard content is always text, so compression is intentionally ignored.
  var clipboardExportFormat: Export.Format {
    baseExportFormat
  }
}
