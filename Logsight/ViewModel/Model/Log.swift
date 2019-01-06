import Foundation

/// Used throughout the application to represent one log.
/// Note that logs that don't comply with this structure
/// are ignored (invalid log level, or no message).
struct Log {
    
    /// The parsed date of the log.
    let date: Date
    
    /// The application name, as deducted from the name
    /// of the file that was dropped.
    let application: Application
    
    /// The log level.
    let level: LogLevel
    
    /// The plain text message of the log, found at the
    /// JSON key "message" or "stack_trace" if any.
    let message: String
    
    /// An arbitrary set of data found in the JSON file.
    /// Keys already used for standard information like date,
    /// message, level, etc… were removed from this map.
    /// For JSON deeper than one level, the data will only
    /// contain the first-level keys, and deep values will
    /// be left as raw JSON.
    let data: [String:String]
}
