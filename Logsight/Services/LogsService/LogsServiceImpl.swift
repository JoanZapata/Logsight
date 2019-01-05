import Foundation

class LogsServiceImpl: LogsService {

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
        // TODO
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
        // Simply add at the end for now. TODO: Make sure it stays sorted.
        let initialSize = self.logs.count
        self.logs.append(contentsOf: logs)
        let finalSize = self.logs.count
        delegates.forEach {
            $0.onLogsChanged(withDiffs: [.added(initialSize..<finalSize)])
        }
    }
}
