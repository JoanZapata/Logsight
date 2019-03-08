import Foundation

class ViewModel {
    
    private static let ORDER_BY_LOG_DATE: (Log, Log) -> ComparisonResult =
        { a, b in a.date.compare(b.date) }

    /// Contains all the logs.
    private var allLogs: [Log] = []
    
    /// Contains the current filtering logic
    private var filters: Filters = Filters()
    
    /// A subset of `allLogs`, only contains the logs that
    /// match the `filters`.
    var logs: [Log] = []
    
    /// Used to `tail` and parse log files
    private var fileLoader: FileLoader
    
    /// The list of delegates to notify when there's
    /// a change in the logs.
    private var delegates: [ViewModelDelegate] = []
    
    init(fileLoader: FileLoader) {
        self.fileLoader = fileLoader
        self.fileLoader.delegate = self
    }
    
    /// All `ViewModel` functions are asynchronous by design.
    /// Implement this delegate to receive updates.
    func addDelegate(_ delegate: ViewModelDelegate) {
        delegates.append(delegate)
    }
    
    /// Start reading from all files previously retained
    /// using `startReadingNewFile(withUrl:)` if they still exist.
    /// Should be called once when the app starts.
    func startReadingPreviouslyAddedApplications() {
        fileLoader.startReadingExistingSecurityBookmarks()
    }
    
    /// Start reading from a new file. Note that it retains
    /// a security bookmark and persists it so that it can
    /// be read again using `startReadingExistingSecurityBookmarks`
    /// automatically read on the next app start.
    func startReading(fileWithUrl url: URL) {
        fileLoader.loadFile(withURL: url)
    }
    
    /// Stop listening to the given file name and delete the
    /// associated security bookmark to completely forget about it.
    /// Use the name given by the delegate.
    func stopReading(application: Application) {
        // Remove all logs
        let (newLogs, diffs) = allLogs.differentialUpdateFilter(
            unfilteredList: allLogs,
            wasKeeping: { filters.apply(item: $0) },
            nowKeeps: { filters.apply(item: $0) && $0.application.filePath != application.filePath }
        )
        allLogs = allLogs
            .filter { $0.application.filePath != application.filePath }
        logs = newLogs
        filters.keepApplications = filters.keepApplications?
            .filter { $0.filePath != application.filePath }
        
        // Stop reading the application log file
        fileLoader.stopReadingAndForget(application: application)
        
        // Notify delegates
        delegates.forEach {
            $0.onLogsChanged(withDiffs: diffs)
            $0.onStopListening(toApplication: application)
        }
    }
    
    /// Sets the log level filter. If set to null, it retains
    /// all logs. If set to any log level, it only retains
    /// log levels that are equal to it or higher.
    func setLogLevelFilter(logLevels: [LogLevel]?) {
        
        // Update filters
        let oldFilters = filters
        filters.keepLogLevels = logLevels
        
        // Compute the diff and update the logs
        let (newLogs, diffs) = allLogs.differentialUpdateFilter(
            unfilteredList: allLogs,
            wasKeeping: { oldFilters.apply(item: $0) },
            nowKeeps: { filters.apply(item: $0) }
        )
        logs = newLogs
        
        // Notify the delegates
        delegates.forEach {
            $0.onLogsChanged(withDiffs: diffs)
        }
    }
    
    /// Sets the application filter. If set to null, it retinas
    /// all applications. Otherwise logs than don't belong to
    /// the given applications are filtered out.
    func setApplicationFilter(applications: [Application]?) {
        
        // Update filters
        let oldFilters = filters
        filters.keepApplications = applications
        
        // Compute the diff and update the logs
        let (newLogs, diffs) = allLogs.differentialUpdateFilter(
            unfilteredList: allLogs,
            wasKeeping: { oldFilters.apply(item: $0) },
            nowKeeps: { filters.apply(item: $0) }
        )
        logs = newLogs
        
        // Notify the delegates
        delegates.forEach {
            $0.onLogsChanged(withDiffs: diffs)
        }
    }
}

extension ViewModel : FileLoaderDelegate {
    
    func onNewFileLoading(application: Application) {
        filters.keepApplications?.append(application)
        delegates.forEach { $0.onStartListening(toApplication: application) }
    }
    
    func onNewLogsLoaded(_ logs: [Log]) {
        let (newAllLogs, _) = self.allLogs.differentialAdd(
            logs,
            filteredBy: nil,
            orderWith: ViewModel.ORDER_BY_LOG_DATE
        )
        let (newLogs, diffs) = self.logs.differentialAdd(
            logs,
            filteredBy: { self.filters.apply(item: $0) },
            orderWith: ViewModel.ORDER_BY_LOG_DATE
        )
        
        self.allLogs = newAllLogs
        self.logs = newLogs
        
        delegates.forEach {
            $0.onLogsChanged(withDiffs: diffs)
        }
    }
}

private struct Filters {
    
    var keepApplications: [Application]? = nil
    var keepLogLevels: [LogLevel]? = nil

    func apply(item: Log) -> Bool {
        let keepApplication = keepApplications?.contains(item.application) ?? true
        let keepLogLevel = keepLogLevels?.contains(item.level) ?? true
        return keepApplication && keepLogLevel
    }
}
