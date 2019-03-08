import Foundation

// A set of counters kept up-to-date by the ViewModel.
// Note that all counts concern the list of logs as of
// what remains after the filters are applied.
struct Counters {
    
    // The total count of displayed logs.
    var totalLogs: Int = 0
}
