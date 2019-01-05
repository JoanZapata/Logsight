@testable import Logsight

extension LogsDiff: Equatable {
    public static func == (lhs: LogsDiff, rhs: LogsDiff) -> Bool {
        switch (lhs, rhs) {
        case (.added(let indexes1), .added(let indexes2)):
            return indexes1 == indexes2
        case (.removed(let indexes1), .removed(let indexes2)):
            return indexes1 == indexes2
        default:
            return false
        }
    }
}
