import Foundation

class ViewModel {

    /// Contains all the logs.
    private var allLogs: [Log] = []
    
    /// A subset of `allLogs`, only contains the displayed
    /// logs, those which satisfies the currently set filters.
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
        // TODO
        
        // Stop reading the application log file
        fileLoader.stopReadingAndForget(application: application)
        
        // Notify delegates
        delegates.forEach { $0.onStopListening(toApplication: application) }
    }
    
    /// Sets the log level filter. If set to null, it retains
    /// all logs. If set to any log level, it only retains
    /// log levels that are equal to it or higher.
    func setLogLevelFilter(logLevel: LogLevel?) {
        // TODO
    }
    
    /// Sets the application filter. If set to null, it retinas
    /// all applications. Otherwise logs than don't belong to
    /// the given applications are filtered out.
    func setApplicationFilter(applications: [Application]?) {
        // TODO
    }
}

extension ViewModel : FileLoaderDelegate {
    
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
