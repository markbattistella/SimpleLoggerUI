//
// Project: SimpleLoggerUI
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SimpleLogger
import SwiftUI

/// A view that displays a list of log entries with search and filter functionalities. Users can
/// filter logs by category and level, and search within log messages.
public struct LogListScreen: View {

    // MARK: - State Properties

    /// The text used to filter logs based on their messages.
    @State private var searchText: String = ""

    /// The list of logs to display.
    @State private var logs: [OSLogEntryLog]

    /// The set of categories selected for filtering logs.
    @State private var selectedCategories: Set<String> = []

    /// The set of log levels selected for filtering logs.
    @State private var selectedLevels: Set<OSLogEntryLog.Level> = []

    /// A Boolean value that determines whether the filter sheet is presented.
    @State private var isFilterSheetPresented: Bool = false

    // MARK: - Computed Properties

    /// An array of unique categories derived from the logs for filtering.
    private var categories: [String] {
        Array(Set(logs.map { $0.category })).sorted()
    }

    /// An array of unique log levels derived from the logs for filtering.
    private var levels: [OSLogEntryLog.Level] {
        Array(Set(logs.map { $0.level })).sorted { $0.rawValue < $1.rawValue }
    }

    /// Filters logs based on the search text, selected categories, and selected levels.
    private var filteredLogs: [OSLogEntryLog] {
        logs.filter { log in
            (searchText.isEmpty || log.composedMessage.localizedCaseInsensitiveContains(searchText))
                && (selectedCategories.isEmpty || selectedCategories.contains(log.category))
                && (selectedLevels.isEmpty || selectedLevels.contains(log.level))
        }
    }

    // MARK: - Initializer

    /// Initializes the `LogListScreen` with a given list of logs.
    ///
    /// - Parameter logs: The logs to be displayed in the list.
    public init(logs: [OSLogEntryLog]) {
        self.logs = logs
    }

    // MARK: - Body

    public var body: some View {
        VStack {
            List(filteredLogs) { log in
                LogCell(for: log)
            }
            .navigationTitle("View Logs")

            #if !os(macOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif

            .searchable(text: $searchText)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button {
                        isFilterSheetPresented.toggle()
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                    .opacity(logs.isEmpty ? 0 : 1)
                }
            }
            .overlay {
                if filteredLogs.isEmpty {
                    VStack {
                        Text("No log entries found")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                }
            }
        }
        .sheet(isPresented: $isFilterSheetPresented) {
            FilterSheet(
                selectedCategories: $selectedCategories,
                selectedLevels: $selectedLevels,
                categories: categories,
                levels: levels
            )
            .presentationDetents([.height(200)])
        }
    }
}
