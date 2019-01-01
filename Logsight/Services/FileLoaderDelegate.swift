import Foundation

protocol FileLoaderDelegate {
    
    func onNewLogsLoaded(_ logs: [Log])
}
