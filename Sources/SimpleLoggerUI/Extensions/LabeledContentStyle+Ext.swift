//
// Project: SimpleLoggerUI
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SwiftUI

/// A labeled content style that arranges the label and content vertically, with the label 
/// displayed above the content.
public struct VerticalLabeledContentStyle: LabeledContentStyle {

    // MARK: - Methods

    /// Creates the view for the labeled content by arranging the label and content vertically.
    ///
    /// - Parameter configuration: A configuration containing the label and content to display.
    /// - Returns: A view that stacks the label and content vertically with the label in bold.
    public func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
                .fontWeight(.bold)
            configuration.content
        }
        .padding(.bottom, 4)
    }
}

// MARK: - LabeledContentStyle Extension

extension LabeledContentStyle where Self == VerticalLabeledContentStyle {

    /// A convenience property to apply the vertical labeled content style.
    public static var vertical: VerticalLabeledContentStyle { Self() }
}
