@testable import Logsight

extension Log : Equatable {
    public static func == (lhs: Log, rhs: Log) -> Bool {
        return lhs.application.filePath == rhs.application.filePath
            && lhs.data == rhs.data
            && lhs.date == rhs.date
            && lhs.level == rhs.level
            && lhs.message == rhs.message
    }
}
