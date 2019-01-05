import Foundation

/// Describes a change in the list of logs expressed as
/// a differential. Can be used to update a list in an
/// effective way.
enum LogsDiff {
    
    /// The given rows were added
    case added(CountableRange<Int>)
    
    /// The given rows were removed
    case removed(CountableRange<Int>)
}
