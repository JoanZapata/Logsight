import Foundation

class MenuViewModel {
    
    var logLevels: [String] = []
    var applications: [Application] = []
    var delegate: MenuViewModelDelegate? {
        didSet {
            delegate?.onLogLevelsChange(logLevels: logLevels)
            delegate?.onApplicationsChange(applications: applications)
        }
    }
    
    init(logsService: LogsService) {
        logsService.addDelegate(self)
    }
}

extension MenuViewModel: LogsServiceDelegate {
    
    func onStartListening(toApplication application: Application) {
        applications.append(application)
        delegate?.onApplicationsChange(applications: applications)
    }
}

protocol MenuViewModelDelegate {
    
    func onLogLevelsChange(logLevels: [String])
    
    func onApplicationsChange(applications: [Application])
}
