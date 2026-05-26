//
// Project: SimpleLoggerUI
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SimpleLogger
import SwiftUI

#Preview {
  NavigationStack {
    LogListScreen.FilterSheet.LogLevelPicker()
  }
  .environment(LoggerManager())
}

extension LogListScreen.FilterSheet {

  /// A view that allows the user to select which log levels are included in the active filter.
  ///
  /// `LogLevelPicker` presents all available log levels in a multi-selection list and provides
  /// a convenience action to quickly select or deselect all levels.
  internal struct LogLevelPicker: View {

    /// The shared logger manager that stores the selected log levels.
    @Environment(LoggerManager.self)
    private var logManager

    var body: some View {
      #if os(watchOS)
        List {
          Section {
            ForEach(LogLevel.allCases) { level in
              Button {
                toggle(level)
              } label: {
                HStack {
                  Text(level.description)
                  Spacer()
                  if logManager.levels.contains(level) {
                    Image(systemName: "checkmark")
                  }
                }
              }
            }
          }

          Section {
            toggleAllButton
          } footer: {
            Text("When all the levels are unselected, no logs will be shown.")
          }
        }
        .navigationTitle("Filter Log Levels")
        .navigationBarTitleDisplayMode(.inline)
      #else
        List(selection: Bindable(logManager).levels) {
          Section {
            ForEach(LogLevel.allCases) { level in
              Text(level.description)
                .tag(level)
                .id(level)
            }
          }

          Section {
            toggleAllButton
          } footer: {
            Text("When all the levels are unselected, no logs will be shown.")
          }
        }
        .navigationTitle("Filter Log Levels")

        #if os(iOS) || os(tvOS) || os(visionOS)
          .environment(\.editMode, .constant(.active))
        #endif

        #if os(iOS) || os(visionOS)
          .navigationBarTitleDisplayMode(.inline)
        #endif
      #endif
    }

    /// Selects or deselects all levels based on the current selection.
    private var toggleAllButton: some View {
      Button(logManager.levels.isEmpty ? "Select all levels" : "Deselect all levels") {
        logManager.levels =
          logManager.levels.isEmpty
          ? Set(LogLevel.allCases) : []
      }
    }

    /// Toggles a single level for platforms without editable multi-selection lists.
    private func toggle(_ level: LogLevel) {
      if logManager.levels.contains(level) {
        logManager.levels.remove(level)
      } else {
        logManager.levels.insert(level)
      }
    }
  }
}
