//
// Project: SimpleLoggerUI
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SimpleLogger
import SwiftUI

extension LogListScreen.FilterSheet {

  /// A view that allows the user to filter logs by a start and end date.
  ///
  /// `DateRange` presents two date pickers that define an inclusive range. The selectable
  /// bounds of each picker are constrained to ensure the start date does not exceed the end
  /// date, and vice versa.
  internal struct DateRange: View {

    /// The shared logger manager that stores the active date range.
    @Environment(LoggerManager.self)
    private var logManager

    var body: some View {
      #if os(tvOS)
        DateSelectionControl(
          title: "Start date",
          selection: Bindable(logManager).dateRangeStart,
          bounds: .distantPast...logManager.dateRangeEnd
        )

        DateSelectionControl(
          title: "End date",
          selection: Bindable(logManager).dateRangeEnd,
          bounds: logManager.dateRangeStart...Date.distantFuture
        )
      #else
        DatePicker(
          "Start date",
          selection: Bindable(logManager).dateRangeStart,
          in: ...logManager.dateRangeEnd,
          displayedComponents: .date
        )

        DatePicker(
          "End date",
          selection: Bindable(logManager).dateRangeEnd,
          in: logManager.dateRangeStart...,
          displayedComponents: .date
        )
      #endif
    }
  }
}
