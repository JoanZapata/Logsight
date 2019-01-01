import Foundation

class LogsViewModel {
    
    private(set) var logs: [Log] = []
    
    private(set) var columns: Set<String> = []
    
    var delegate: MainViewModelDelegate?
    
    let fileLoader: FileLoader
    
    init(fileLoader: FileLoader) {
        self.fileLoader = fileLoader
        fileLoader.addDelegate(delegate: self)
    }
    
    func loadNewFile(url: URL) {
        fileLoader.loadFile(withURL: url)
    }
}

extension LogsViewModel : FileLoaderDelegate {
    
    func onNewLogsLoaded(_ logs: [Log]) {
        let initialSize = self.logs.count
        self.logs.append(contentsOf: logs)
        let finalSize = self.logs.count
        delegate?.logsDidUpdate(update: .added(initialSize..<finalSize))
    }
}

protocol MainViewModelDelegate {
    
    func logsDidUpdate(update: LogsUpdate)
}

enum LogsUpdate {
    
    case added(CountableRange<Int>)
}
