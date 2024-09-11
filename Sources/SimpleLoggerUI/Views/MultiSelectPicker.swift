//
// Project: SimpleLoggerUI
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SwiftUI

/// A view that provides a menu-based multi-select picker, allowing users to select multiple 
/// options from a list. The picker displays the selected count and highlights selected options
/// with a checkmark.
internal struct MultiSelectPicker<T: Hashable & CustomStringConvertible>: View {

    // MARK: - Properties

    /// The title displayed on the picker button.
    internal let title: String

    /// The list of options available for selection.
    internal let options: [T]

    /// A binding to the set of selected options, allowing the parent view to track and 
    /// respond to changes.
    @Binding internal var selectedOptions: Set<T>

    // MARK: - Body

    internal var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    toggleSelection(for: option)
                }) {
                    Label(
                        option.description,
                        systemImage: selectedOptions.contains(option) ? "checkmark.square" : "square"
                    )
                }
            }
        } label: {
            HStack {
                Text(title)
                Spacer()
                Text(selectedOptions.isEmpty ? "None" : "\(selectedOptions.count) selected")
                    .foregroundColor(.gray)
            }
        }
    }

    // MARK: - Private Methods

    /// Toggles the selection state of a given option.
    ///
    /// - Parameter option: The option to be toggled in the selected options set.
    private func toggleSelection(for option: T) {
        if selectedOptions.contains(option) {
            selectedOptions.remove(option)
        } else {
            selectedOptions.insert(option)
        }
    }
}
