import Foundation

class MainViewModel {
    
    let logsViewModel: LogsViewModel
    let menuViewModel: MenuViewModel
    
    init(fileLoader: FileLoader) {
        self.logsViewModel = LogsViewModel(fileLoader: fileLoader)
        self.menuViewModel = MenuViewModel(fileLoader: fileLoader)
    }
}
