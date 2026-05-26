//
// Project: SimpleLoggerUI
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SwiftUI

extension LogListScreen.FilterSheet {

  /// A tvOS-compatible hour selector for filters where `Stepper` is unavailable.
  internal struct HourSelectionControl: View {

    /// The label shown beside the selected hour.
    let title: String

    /// The selected hour value.
    @Binding
    var selection: Int

    /// The inclusive selectable hour bounds.
    let bounds: ClosedRange<Int>

    var body: some View {
      VStack(alignment: .leading) {
        LabeledContent(title, value: formattedHour)
          .monospacedDigit()

        HStack {
          Button("Decrease \(title)", systemImage: "minus") {
            selection -= 1
          }
          .disabled(selection <= bounds.lowerBound)

          Button("Increase \(title)", systemImage: "plus") {
            selection += 1
          }
          .disabled(selection >= bounds.upperBound)
        }
      }
    }

    private var formattedHour: String {
      selection == 24 ? "24:00" : "\(selection):00"
    }
  }
}
