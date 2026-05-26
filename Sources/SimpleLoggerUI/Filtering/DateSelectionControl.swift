//
// Project: SimpleLoggerUI
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SwiftUI

extension LogListScreen.FilterSheet {

  /// A tvOS-compatible date selector for filters where `DatePicker` is unavailable.
  internal struct DateSelectionControl: View {

    /// The label shown beside the selected date.
    let title: String

    /// The selected date.
    @Binding
    var selection: Date

    /// The inclusive selectable date bounds.
    let bounds: ClosedRange<Date>

    private let calendar = Calendar.autoupdatingCurrent

    var body: some View {
      VStack(alignment: .leading) {
        LabeledContent(
          title,
          value: selection,
          format: .dateTime.year().month().day()
        )

        HStack {
          Button("Previous \(title)", systemImage: "chevron.left") {
            adjust(by: -1)
          }
          .disabled(!canAdjust(by: -1))

          Button("Next \(title)", systemImage: "chevron.right") {
            adjust(by: 1)
          }
          .disabled(!canAdjust(by: 1))
        }
      }
    }

    private func adjust(by days: Int) {
      guard let date = adjustedDate(by: days) else { return }
      selection = date
    }

    private func canAdjust(by days: Int) -> Bool {
      guard let date = adjustedDate(by: days) else { return false }
      return selectableDays.contains(date)
    }

    private func adjustedDate(by days: Int) -> Date? {
      calendar.date(
        byAdding: .day,
        value: days,
        to: calendar.startOfDay(for: selection)
      )
    }

    private var selectableDays: ClosedRange<Date> {
      calendar.startOfDay(for: bounds.lowerBound)...calendar.startOfDay(for: bounds.upperBound)
    }
  }
}
