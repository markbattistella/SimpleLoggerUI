//
// Project: SimpleLoggerUI
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SimpleLogger
import SwiftUI
import UniformTypeIdentifiers

/// A view that provides an interface for exporting logs, with various filtering and action options.
public struct LogExportScreen: View {

    // MARK: - State Properties

    @StateObject private var vm: LoggerManager
    @State private var showFileExporter: Bool = false
    @State private var logFileDocument: MultiTypeFileDocument?
    @State private var logFileDocumentType: UTType = .log
    @State private var selectedExport: UTType = .log
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var showToast: Bool = false

    // MARK: - Private Properties

    private let navigationTitle: String
    private let logger = SimpleLogger(category: .fileSystem)

    #if !os(macOS)
    private let navigationBarTitleDisplayMode: NavigationBarItem.TitleDisplayMode
    #endif

    // MARK: - Initializer

    #if !os(macOS)

    /// Initializes the LogExportScreen with the required parameters.
    ///
    /// - Parameters:
    ///   - vm: The logger manager responsible for handling log data.
    ///   - navigationTitle: The title displayed in the navigation bar.
    ///   - navigationBarTitleDisplayMode: The display mode for the navigation bar title.
    public init(
        vm: LoggerManager,
        navigationTitle: String = "Export Logs",
        navigationBarTitleDisplayMode: NavigationBarItem.TitleDisplayMode = .large
    ) {
        self._vm = StateObject(wrappedValue: vm)
        self.navigationTitle = navigationTitle
        self.navigationBarTitleDisplayMode = navigationBarTitleDisplayMode
    }

    #else

    /// Initializes the LogExportScreen with the required parameters.
    ///
    /// - Parameters:
    ///   - vm: The logger manager responsible for handling log data.
    ///   - navigationTitle: The title displayed in the navigation bar.
    ///   - navigationBarTitleDisplayMode: The display mode for the navigation bar title.
    public init(
        vm: LoggerManager,
        navigationTitle: String = "Export Logs"
    ) {
        self._vm = StateObject(wrappedValue: vm)
        self.navigationTitle = navigationTitle
    }

    #endif

    // MARK: - Body

    public var body: some View {
        Form {
            filterTypeSection
            filterOptions
            actionButtonsSection
            NavigationLink {
                LogListScreen(logs: vm.logs)
            } label: {
                Label("View logs", systemImage: "doc.plaintext")
            }
        }
        .navigationTitle(navigationTitle)

        #if !os(macOS)
        .navigationBarTitleDisplayMode(navigationBarTitleDisplayMode)
        #endif

        .interactiveDismissDisabled()
        .opacity(vm.isExporting ? 0.6 : 1)
        .disabled(vm.isExporting)
        .animation(.easeInOut, value: vm.isExporting)
        .toolbar { toolbarComponents }
        .task { try? await vm.fetchLogEntries() }
        .onChange(of: vm.excludeSystemLogs) { _ in
            Task { try? await vm.fetchLogEntries() }
        }
        .fileExporter(
            isPresented: $showFileExporter,
            document: logFileDocument,
            contentType: selectedExport
        ) { result in
            handleFileExportResult(result)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

// MARK: - Private Methods

extension LogExportScreen {

    /// Copies logs to the clipboard in plain text format.
    private func copyToClipboard() {
        Task {
            let logs = vm.exportLogs(as: .plainText)
            let contentToPaste = logs.isEmpty ? "Nothing to paste" : logs
            setToPasteBoard(contentToPaste)
            showToast = true
        }
    }

    /// Exports the log file in the specified format and presents the file exporter.
    /// - Parameter type: The type of file format to export the logs as.
    private func exportLogFile(type: UTType) {
        guard self.logFileDocument == nil else {
            self.showFileExporter.toggle()
            return
        }
        Task {
            do {
                let url = createLogFileURL(for: type)
                try await vm.writeLogs(as: type, to: url)
                await MainActor.run {
                    self.logFileDocument = MultiTypeFileDocument(file: url, fileType: type)
                    self.showFileExporter = true
                }
            } catch {
                logger.error("Error writing logs to file: \(error.localizedDescription)")
                alertMessage = "Failed to write logs to file: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }

    /// Shares the log file in the specified format.
    ///
    /// - Parameter type: The type of file format for sharing the logs.
    /// - Returns: A URL pointing to the location of the shared log file.
    private func shareLogFile(type: UTType) -> URL {
        let url = createLogFileURL(for: type)
        Task {
            do {
                try await vm.writeLogs(as: type, to: url)
            } catch {
                logger.error("Error sharing log file: \(error.localizedDescription)")
            }
        }
        return url
    }

    /// Creates a URL for saving the log file based on the current process and timestamp.
    ///
    /// - Parameter type: The type of file format for the logs.
    /// - Returns: A URL pointing to the location of the log file.
    private func createLogFileURL(for type: UTType) -> URL {
        let fileName = "\(ProcessInfo.processInfo.processName)-\(Date().timeIntervalSince1970)"
        let fileExtension = type.fileExtension
        let fullFile = "\(fileName).\(fileExtension)"
        return URL.temporaryDirectory.appendingPathComponent(fullFile)
    }

    /// Handles the result of the file export operation.
    ///
    /// - Parameter result: A result containing either a URL of the exported file or an error.
    private func handleFileExportResult(_ result: Result<URL, Error>) {
        switch result {
            case .success:
                break
            case .failure(let error):
                logger.error("Error exporting file: \(error, privacy: .public)")
                alertMessage = "Failed to export the file: \(error.localizedDescription)"
                showAlert = true
        }
        self.logFileDocument = nil
    }

    /// Sets the provided string to the system clipboard.
    ///
    /// - Parameter string: The string to be copied to the clipboard.
    private func setToPasteBoard(_ string: String) {
        #if os(macOS)
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(string, forType: .string)
        #else
        UIPasteboard.general.string = string
        #endif
    }
}

// MARK: - View Components

extension LogExportScreen {

    /// A group of toolbar components.
    @ToolbarContentBuilder
    private var toolbarComponents: some ToolbarContent {
        ToolbarItemGroup(placement: .navigation) {
            overlayProgress
            copiedConfirmation
        }
    }

    /// A view displaying the overlay progress indicator when exporting.
    private var overlayProgress: some View {
        ProgressView()
            .padding(4)
            .background(Color(.gray).opacity(0.2))
            .clipShape(.rect(cornerRadius: 8))
            .opacity(vm.isExporting ? 1 : 0)
            .transition(.opacity)
    }

    /// A view displaying a confirmation message when content is copied to the clipboard.
    private var copiedConfirmation: some View {
        Text("Copied!")
            .font(.caption)
            .padding(.vertical, 8)
            .padding(.horizontal, 8)
            .background(Color(.gray).opacity(0.2))
            .clipShape(.rect(cornerRadius: 8))
            .opacity(showToast ? 1 : 0)
            .transition(.opacity)
    }

    /// A section view for selecting the log filter type.
    private var filterTypeSection: some View {
        Section {
            Picker("Filter by", selection: $vm.filterType) {
                ForEach(LoggerManager.FilterType.allCases, id: \.self) { type in
                    Text(type.description).tag(type)
                }
            }
            filterBySegments
        } header: {
            Text("Filter")
        } footer: {
            Text(filterFooterText)
        }
    }

    /// A section view for log export and filtering options.
    private var filterOptions: some View {
        Section {
            Toggle("Exclude system logs", isOn: $vm.excludeSystemLogs)
            Picker("Export filetype", selection: $selectedExport) {
                ForEach(vm.exportFileExtensions, id: \.self) { type in
                    Text(type.description).tag(type)
                }
            }
        } header: {
            Text("Options")
        } footer: {
            Text(
                "If you activate **Exclude system logs** then only entries linked to this app's identifier will be extracted."
            )
        }
    }

    /// A section view for action buttons including copy, export, and share log file.
    private var actionButtonsSection: some View {
        Section {
            ActionButton("Copy to clipboard", systemImage: "doc.on.doc") {
                copyToClipboard()
            }

            ActionButton("Export log file", systemImage: "square.and.arrow.down") {
                exportLogFile(type: selectedExport)
            }

            ShareLink(item: shareLogFile(type: selectedExport)) {
                Label("Share log file", systemImage: "square.and.arrow.up")
            }
        }
    }

    /// A segmented control to refine log filters based on selected type.
    @ViewBuilder
    private var filterBySegments: some View {
        switch vm.filterType {
            case .specificDate: specificDateSegment
            case .dateRange: dateRangeSegment
            case .hourRange: hourRangeSegment
            case .preset: presetSegment
        }
    }

    /// A view for selecting a specific date for log filtering.
    private var specificDateSegment: some View {
        DatePicker(
            "Specific date",
            selection: $vm.specificDate,
            in: ...Date.now,
            displayedComponents: .date
        )
    }

    /// A view for selecting a date range for log filtering.
    private var dateRangeSegment: some View {
        Group {
            DatePicker(
                "Start date",
                selection: $vm.dateRangeStart,
                in: ...vm.dateRangeFinish,
                displayedComponents: .date
            )
            DatePicker(
                "Finish date",
                selection: $vm.dateRangeFinish,
                in: vm.dateRangeStart...,
                displayedComponents: .date
            )
        }
    }

    /// A view for selecting an hour range within a specific date for log filtering.
    private var hourRangeSegment: some View {
        Group {
            DatePicker(
                "Specific date",
                selection: $vm.specificDate,
                in: ...Date.now,
                displayedComponents: .date
            )
            DatePicker(
                "Start time",
                selection: $vm.hourRangeStart,
                in: ...vm.hourRangeFinish,
                displayedComponents: .hourAndMinute
            )
            DatePicker(
                "Finish time",
                selection: $vm.hourRangeFinish,
                in: vm.hourRangeStart...,
                displayedComponents: .hourAndMinute
            )
        }
    }

    /// A view for selecting preset options for quick log filtering.
    private var presetSegment: some View {
        Picker("Preset option", selection: $vm.selectedPreset) {
            ForEach(LoggerManager.Preset.allCases, id: \.self) { preset in
                Text("Last \(preset.description)").id(preset)
            }
        }
    }

    /// Provides descriptive text for the footer of the filter section.
    private var filterFooterText: String {
        switch vm.filterType {
            case .specificDate:
                return
                    "Select a specific date to filter logs from that day only. All times are considered within the selected date."
            case .dateRange:
                return
                    "Choose a start and end date to filter logs within a specific date range. Logs from both dates will be included."
            case .hourRange:
                return
                    "Set a specific date and a range of hours to narrow down logs to a precise time window within the chosen day."
            case .preset:
                return
                    "Select a preset option to quickly apply common date and time filters without manual adjustments."
        }
    }
}
