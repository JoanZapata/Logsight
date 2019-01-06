@testable import Logsight

extension Diffs: Equatable {
    public static func == (lhs: Diffs, rhs: Diffs) -> Bool {
        return lhs.added == rhs.added && lhs.removed == rhs.removed
    }
}
