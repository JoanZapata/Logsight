import Foundation

protocol LogsService {
    
    /// The current list of logs
    var logs: [Log] { get }
    
    /// All `LogsService` functions are asynchronous by design.
    /// Implement this delegate to receive updates.
    func addDelegate(_ delegate: LogsServiceDelegate)
    
    /// Start reading from all files previously retained
    /// using `startReadingNewFile(withUrl:)` if they still exist.
    /// Should be called once when the app starts.
    func startReadingPreviouslyAddedApplications()
    
    /// Start reading from a new file. Note that it retains
    /// a security bookmark and persists it so that it can
    /// be read again using `startReadingExistingSecurityBookmarks`
    /// automatically read on the next app start.
    func startReading(fileWithUrl url: URL)
    
    /// Stop listening to the given file name and delete the
    /// associated security bookmark to completely forget about it.
    /// Use the name given by the delegate.
    func stopReading(application: Application)
    
    /// Sets the log level filter. If set to null, it retains
    /// all logs. If set to any log level, it only retains
    /// log levels that are equal to it or higher.
    func setLogLevelFilter(logLevel: LogLevel?)
    
    /// Sets the application filter. If set to null, it retinas
    /// all applications. Otherwise logs than don't belong to
    /// the given applications are filtered out.
    func setApplicationFilter(applications: [Application]?)
}
