import Foundation

class LogsServiceImpl: LogsService {

    /// Contains all the logs.
    private var allLogs: [Log] = []
    
    /// A subset of `allLogs`, only contains the displayed
    /// logs, those which satisfies the currently set filters.
    var logs: [Log] = []
    
    /// Used to `tail` and parse log files
    private var fileLoader: FileLoader
    
    /// The list of delegates to notify when there's
    /// a change in the logs.
    private var delegates: [LogsServiceDelegate] = []
    
    init(fileLoader: FileLoader) {
        self.fileLoader = fileLoader
        self.fileLoader.delegate = self
    }
    
    func addDelegate(_ delegate: LogsServiceDelegate) {
        delegates.append(delegate)
    }
    
    func startReadingPreviouslyAddedApplications() {
        fileLoader.startReadingExistingSecurityBookmarks()
    }
    
    func startReading(fileWithUrl url: URL) {
        fileLoader.loadFile(withURL: url)
    }
    
    func stopReading(application: Application) {
        // Remove all logs
        // TODO
        
        // Stop reading the application log file
        fileLoader.stopReadingAndForget(application: application)
        
        // Notify delegates
        delegates.forEach { $0.onStopListening(toApplication: application) }
    }
    
    func setLogLevelFilter(logLevel: LogLevel?) {
        // TODO
    }
    
    func setApplicationFilter(applications: [Application]?) {
        // TODO
    }
}

extension LogsServiceImpl : FileLoaderDelegate {
    
    func onNewFileLoading(application: Application) {
        delegates.forEach { $0.onStartListening(toApplication: application) }
    }
    
    func onNewLogsLoaded(_ logs: [Log]) {
        let logDateAscending: (Log, Log) -> ComparisonResult = { a, b in a.date.compare(b.date) }
        let (newLogs, diffs) = self.allLogs.differentialAdd(logs, orderWith: logDateAscending)
        self.allLogs = newLogs
        self.logs = newLogs
        
        delegates.forEach {
            $0.onLogsChanged(withDiffs: diffs)
        }
    }
}
