@testable import Logsight

class FakeViewModelDelegate: ViewModelDelegate {
    var lastReceivedDiff: Diffs? = nil
    
    func onLogsChanged(withDiffs diffs: Diffs) {
        self.lastReceivedDiff = diffs
    }
}
