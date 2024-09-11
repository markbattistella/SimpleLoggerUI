//
// Project: SimpleLoggerUI
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SwiftUI

/// A customizable button view that displays a label with a title and system image, and performs
/// an action when tapped.
internal struct ActionButton: View {
    
    // MARK: - Private Properties
    
    /// The title text displayed on the button.
    private let title: String
    
    /// The name of the system image displayed alongside the title.
    private let systemImage: String
    
    /// The action to perform when the button is tapped.
    private let action: () -> Void
    
    // MARK: - Initializer
    
    /// Initializes the `ActionButton` with a title, system image, and action closure.
    ///
    /// - Parameters:
    ///   - title: The title text for the button.
    ///   - systemImage: The name of the system image to display with the title.
    ///   - action: The closure to execute when the button is tapped.
    internal init(
        _ title: String,
        systemImage: String,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.action = action
    }
    
    // MARK: - Body
    
    internal var body: some View {
        Button(action: action) {
            HStack {
                Label(title, systemImage: systemImage)
            }
        }
        .accessibilityLabel(title)
    }
}
