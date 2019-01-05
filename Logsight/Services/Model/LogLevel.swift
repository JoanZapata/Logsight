import Foundation

enum LogLevel {
    case trace, debug, info, warn, error
    
    static func from(string levelString: String) -> LogLevel? {
        switch levelString.uppercased() {
        case "TRACE": return .trace
        case "DEBUG": return .debug
        case "INFO": return .info
        case "WARN": return .warn
        case "ERROR": return .error
        default: return nil
        }
    }
}
