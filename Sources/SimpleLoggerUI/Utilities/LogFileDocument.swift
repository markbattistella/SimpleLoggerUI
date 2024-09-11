//
// Project: SimpleLoggerUI
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import UniformTypeIdentifiers
import SwiftUI

/// A file document that supports multiple types for reading and writing log data.
internal final class MultiTypeFileDocument: FileDocument {

    // MARK: - Static Properties

    /// Defines the content types that this document can read.
    internal static let readableContentTypes: [UTType] = [.log, .json, .plainText, .commaSeparatedText]

    // MARK: - Public Properties

    /// The URL of the file to be managed by the document.
    public let file: URL

    /// The type of the file that determines the content type for reading and writing.
    public let fileType: UTType

    // MARK: - Initializers

    /// Initializes a new document with the specified file URL and type.
    /// - Parameters:
    ///   - file: The URL of the file.
    ///   - fileType: The type of the file content, e.g., `.log`, `.json`.
    public init(file: URL, fileType: UTType) {
        self.file = file
        self.fileType = fileType
    }

    /// Creates a new document from a read configuration. This implementation throws an error as 
    /// reading is not supported.
    ///
    /// - Parameter configuration: The configuration used to read the document.
    /// - Throws: An error indicating that the document type cannot be read.
    internal required init(configuration: ReadConfiguration) throws {
        throw NSError(
            domain: "com.example.logexporter",
            code: -1,
            userInfo: [NSLocalizedDescriptionKey: "This document type cannot be read."]
        )
    }

    // MARK: - Methods

    /// Returns a file wrapper configured for writing the document's contents.
    /// 
    /// - Parameter configuration: The configuration used to write the document.
    /// - Throws: An error if the file cannot be wrapped.
    /// - Returns: A `FileWrapper` representing the file at the specified URL.
    internal func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return try FileWrapper(url: self.file)
    }
}
