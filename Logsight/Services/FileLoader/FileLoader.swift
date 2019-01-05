import Foundation

/// Singleton service used throughout the rest of the app to read log files.
/// Loading files is asynchronous, resulting logs can be retrieved by adding
/// a delegate.
protocol FileLoader {
    
    /// Adds a new delegate. To simplify state synchronization, this new
    /// delegate immediately receives previous data (past logs), then
    /// receives new ones as they arrive.
    func addDelegate(delegate: FileLoaderDelegate)
    
    /// Triggers reading and parsing a new file, asynchronously.
    func loadFile(withURL url: URL)
}
