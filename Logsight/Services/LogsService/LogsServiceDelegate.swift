import Foundation

/// All `LogsService` functions are asynchronous by design.
/// Implement this delegate to receive updates. All functions
/// are optional.
protocol LogsServiceDelegate {
    
    func onStartListening(toApplication application: Application)
    
    func onStopListening(toApplication application: Application)
    
    func onLogLevelFilterChanged(logLevel: LogLevel?)
    
    func onApplicationFilterChanged(applications: [Application]?)
    
    func onLogsChanged(withDiffs diffs: Diffs)
}

// Make all functions optional by providing
// a default no-op implementation
extension LogsServiceDelegate {

    func onStartListening(toApplication application: Application){ }
    
    func onStopListening(toApplication application: Application){ }
    
    func onLogLevelFilterChanged(logLevel: LogLevel?){ }
    
    func onApplicationFilterChanged(applications: [Application]?){ }

    func onLogsChanged(withDiffs diffs: Diffs){ }
}
