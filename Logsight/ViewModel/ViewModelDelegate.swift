import Foundation

/// All `ViewModel` functions are asynchronous by design.
/// Implement this delegate to receive updates. All functions
/// are optional.
protocol ViewModelDelegate {
    
    func onStartListening(toApplication application: Application)
    
    func onStopListening(toApplication application: Application)
    
    func onLogLevelFilterChanged(logLevel: LogLevel?)
    
    func onApplicationFilterChanged(applications: [Application]?)
    
    func onLogsChanged(withDiffs diffs: Diffs)
    
    func onCountersChanged(counters: Counters)
}

// Make all functions optional by providing
// a default no-op implementation
extension ViewModelDelegate {

    func onStartListening(toApplication application: Application){ }
    
    func onStopListening(toApplication application: Application){ }
    
    func onLogLevelFilterChanged(logLevel: LogLevel?){ }
    
    func onApplicationFilterChanged(applications: [Application]?){ }

    func onLogsChanged(withDiffs diffs: Diffs){ }
    
    func onCountersChanged(counters: Counters){ }
}
