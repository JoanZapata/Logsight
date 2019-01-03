import Foundation

class MenuViewModel {
    
    var logLevels: [String] = []
    var applications: [String] = []
    var delegate: MenuViewModelDelegate? {
        didSet {
            delegate?.onLogLevelsChange(logLevels: logLevels)
            delegate?.onApplicationsChange(applications: applications)
        }
    }
    
    init(fileLoader: FileLoader) {
        fileLoader.addDelegate(delegate: self)
    }
}

extension MenuViewModel: FileLoaderDelegate {
    
    func onNewFileLoading(path: String, applicationName: String) {
        applications.append(applicationName)
        delegate?.onApplicationsChange(applications: applications)
    }
}

protocol MenuViewModelDelegate {
    
    func onLogLevelsChange(logLevels: [String])
    
    func onApplicationsChange(applications: [String])
}
