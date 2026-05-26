//
// Project: SimpleLoggerUI
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SimpleLogger
import SwiftUI

extension LogListScreen.FilterSheet {

  /// A view that allows the user to filter logs by a single, specific date.
  ///
  /// `SpecificDate` presents a date picker that limits log results to entries recorded within
  /// the selected calendar day.
  internal struct SpecificDate: View {

    /// The shared logger manager that stores the selected date.
    @Environment(LoggerManager.self)
    private var logManager

    var body: some View {
      #if os(tvOS)
        DateSelectionControl(
          title: "Specific date",
          selection: Bindable(logManager).specificDate,
          bounds: .distantPast...Date.now
        )
      #else
        DatePicker(
          "Specific date",
          selection: Bindable(logManager).specificDate,
          in: ...Date.now,
          displayedComponents: .date
        )
      #endif
    }
  }
}
