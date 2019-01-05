import Foundation

protocol FileLoaderDelegate {
    
    /// Called when new logs were loaded
    func onNewLogsLoaded(_ logs: [Log])
    
    /// Called when a new file is added and read
    func onNewFileLoading(application: Application)
}
