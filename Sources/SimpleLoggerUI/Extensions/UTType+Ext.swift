//
// Project: SimpleLoggerUI
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import UniformTypeIdentifiers

/// An extension of `UTType` to provide additional functionality such as custom file extensions
/// and descriptions.
extension UTType {

    // MARK: - File Extension

    /// Returns the file extension associated with the UTType.
    ///
    /// - Returns: A string representing the file extension for the given UTType.
    public var fileExtension: String {
        switch self {
            case .log: return "log"
            case .json: return "json"
            case .plainText: return "md"
            case .text: return "txt"
            case .commaSeparatedText: return "csv"
            default: return self.preferredFilenameExtension ?? ""
        }
    }

    // MARK: - Description

    /// Provides a human-readable description for the UTType.
    ///
    /// - Returns: A string describing the file type for the given UTType.
    public var description: String {
        switch self {
            case .log: return "Log file"
            case .json: return "JSON"
            case .plainText: return "Markdown"
            case .text: return "Text file"
            case .commaSeparatedText: return "CSV"
            default: return self.preferredFilenameExtension ?? ""
        }
    }
}
