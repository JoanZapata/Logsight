import Cocoa

extension LogLevel {
    func color() -> NSColor {
        switch self {
        case .trace: return NSColor(rgb: 0xC4C4C4, alpha: 0.5)
        case .debug: return NSColor(rgb: 0xC4C4C4)
        case .info: return NSColor(rgb: 0xA4CBE1)
        case .warn: return NSColor(rgb: 0xE5B468)
        case .error: return NSColor(rgb: 0xD35E53)
        }
    }
}
