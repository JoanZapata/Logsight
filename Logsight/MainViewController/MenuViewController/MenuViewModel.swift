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
    
    private let logsService: LogsService
    
    init(logsService: LogsService) {
        self.logsService = logsService
        self.logsService.addDelegate(self)
    }
    
    func removeApplication(_ application: Application) {
        logsService.stopReading(application: application)
    }
}

extension MenuViewModel: LogsServiceDelegate {
    
    func onStartListening(toApplication application: Application) {
        applications.append(application)
        delegate?.onApplicationsChange(applications: applications)
    }
    
    func onStopListening(toApplication application: Application) {
        guard let index = applications.firstIndex(where: { $0.filePath == application.filePath })
            else { return }
        applications.remove(at: index)
        delegate?.onApplicationsChange(applications: applications)
    }
}

protocol MenuViewModelDelegate {
    
    func onLogLevelsChange(logLevels: [String])
    
    func onApplicationsChange(applications: [Application])
}
