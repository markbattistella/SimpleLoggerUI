//
// Project: SimpleLoggerUI
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SimpleLogger
import SwiftUI

/// A view representing a log entry cell, displaying detailed information about the log entry
/// including its date, subsystem, category, level, and message.
internal struct LogCell: View {

    // MARK: - Private Properties

    /// The log entry to be displayed in the cell.
    private let log: OSLogEntryLog

    // MARK: - Initializer

    /// Initializes the `LogCell` with a specific log entry.
    ///
    /// - Parameter log: The log entry to display.
    init(for log: OSLogEntryLog) {
        self.log = log
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading) {
            headerSection
            Divider().background(log.level.color)
            logDetailsSection
        }
        .font(.footnote)
        .listRowBackground(log.level.color.opacity(0.1))
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Private View Components

    /// A view displaying the header section of the log cell with a level icon and formatted date.
    private var headerSection: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(log.level.color)
                    .frame(width: 24, height: 24)
                Image(systemName: log.level.sfSymbol)
                    .frame(width: 22, height: 22)
                    .foregroundStyle(.white)
            }
            Text(log.date.formatted(date: .long, time: .standard))
                .font(.system(.footnote, design: .monospaced))
        }
    }

    /// A view displaying the detailed information of the log entry including subsystem,
    /// category, level, and message.
    private var logDetailsSection: some View {
        Group {
            LabeledContent("Subsystem", value: log.subsystem)
            LabeledContent("Category", value: log.category)
            LabeledContent("Level", value: log.level.description)
            LabeledContent("Message", value: log.composedMessage)
        }
        .labeledContentStyle(.vertical)
    }
}
