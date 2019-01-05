import Foundation

class MainViewModel {
    
    let logsViewModel: LogsViewModel
    let menuViewModel: MenuViewModel
    
    init(logsService: LogsService) {
        self.logsViewModel = LogsViewModel(logsService: logsService)
        self.menuViewModel = MenuViewModel(logsService: logsService)
    }
}
