//
// Project: SimpleLoggerUI
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SimpleLogger
import Testing

@testable import SimpleLoggerUI

@Suite("ExportConfiguration")
struct ExportConfigurationTests {

  @Test("File export uses gzip when compression is enabled")
  func fileExportUsesGzipWhenCompressionIsEnabled() {
    let configuration = ExportConfiguration(
      baseFormat: .jsonLines,
      csvDelimiter: .comma,
      useGzip: true
    )

    #expect(configuration.fileExportFormat == .gzip(.jsonLines))
  }

  @Test("Clipboard export ignores gzip and uses the base format")
  func clipboardExportIgnoresGzipAndUsesBaseFormat() {
    let configuration = ExportConfiguration(
      baseFormat: .jsonLines,
      csvDelimiter: .comma,
      useGzip: true
    )

    #expect(configuration.clipboardExportFormat == .jsonLines)
  }

  @Test("CSV exports keep the selected delimiter")
  func csvExportsKeepTheSelectedDelimiter() {
    let configuration = ExportConfiguration(
      baseFormat: .csv,
      csvDelimiter: .pipe,
      useGzip: false
    )

    #expect(configuration.fileExportFormat == .csv(.pipe))
    #expect(configuration.clipboardExportFormat == .csv(.pipe))
  }
}
