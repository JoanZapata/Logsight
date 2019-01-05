import Foundation

/// Singleton service to read log files. Loading files is asynchronous,
/// resulting logs can be retrieved by adding a delegate.
protocol FileLoader {
    
    /// Sets the delegate. To simplify state synchronization, this new
    /// delegate immediately receives previous data (past logs), it then
    /// receives new ones as they arrive.
    var delegate: FileLoaderDelegate? { get set }
    
    /// Start reading previously retained security bookmarks.
    func startReadingExistingSecurityBookmarks()
    
    /// Triggers reading and parsing a new file, asynchronously.
    func loadFile(withURL url: URL)
    
    /// Stops reading the application log file and forget
    /// the security bookmark.
    func stopReadingAndForget(application: Application)
}
