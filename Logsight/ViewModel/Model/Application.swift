import Foundation

/// An application is created for each file dragged
/// into the application.
struct Application {
    
    /// The name of the app, deducted from the file name.
    /// For example, `/tmp/logs/test.json.log` would give
    /// the application name `test`.
    let name: String
    
    /// The full path to the log file.
    let filePath: String
}
