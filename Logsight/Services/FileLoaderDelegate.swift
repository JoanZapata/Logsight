import Foundation

protocol FileLoaderDelegate {
    
    /// Called when new logs were loaded
    func onNewLogsLoaded(_ logs: [Log])
    
    /// Called when a new file is added and read
    func onNewFileLoading(path: String, applicationName: String)
}

// Make all functions optional by providing
// a default no-op implementation
extension FileLoaderDelegate {
    
    func onNewLogsLoaded(_ logs: [Log]) {}

    func onNewFileLoading(path: String, applicationName: String) {}
}
