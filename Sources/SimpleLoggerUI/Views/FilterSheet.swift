//
// Project: SimpleLoggerUI
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SwiftUI
import OSLog

/// A view that presents a filter sheet allowing users to select categories and log levels. The
/// selections are managed via bindings, enabling the parent view to respond to changes.
internal struct FilterSheet: View {

    // MARK: - Binding Properties

    /// The set of selected categories.
    @Binding var selectedCategories: Set<String>

    /// The set of selected log levels.
    @Binding var selectedLevels: Set<OSLogEntryLog.Level>

    // MARK: - Constant Properties

    /// The list of available categories to choose from.
    let categories: [String]

    /// The list of available log levels to choose from.
    let levels: [OSLogEntryLog.Level]

    // MARK: - Body

    internal var body: some View {
        NavigationStack {
            Form {

                // Multi-select picker for categories
                MultiSelectPicker(
                    title: "Categories",
                    options: categories,
                    selectedOptions: $selectedCategories
                )

                // Multi-select picker for log levels
                MultiSelectPicker(
                    title: "Levels",
                    options: levels,
                    selectedOptions: $selectedLevels
                )
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
