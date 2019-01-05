import Foundation

class LogsViewModel {
    
    private(set) var logs: [Log] = []
    
    private(set) var columns: Set<String> = []
    
    var delegate: LogsViewModelDelegate?
    
    let logsService: LogsService
    
    init(logsService: LogsService) {
        self.logsService = logsService
        self.logsService.addDelegate(self)
    }
    
    func loadNewFile(url: URL) {
        logsService.startReading(fileWithUrl: url)
    }
}

extension LogsViewModel : LogsServiceDelegate {
    
    func onLogsChanged(withDiffs diffs: [LogsDiff]) {
        self.logs = logsService.logs
        delegate?.logsDidUpdate(update: diffs)
    }
}

protocol LogsViewModelDelegate {
    
    func logsDidUpdate(update: [LogsDiff])
}
