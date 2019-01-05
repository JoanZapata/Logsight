@testable import Logsight

class FakeLogsServiceDelegate: LogsServiceDelegate {
    var lastReceivedDiff: [LogsDiff]? = nil
    
    func onLogsChanged(withDiffs diffs: [LogsDiff]) {
        self.lastReceivedDiff = diffs
    }
}
