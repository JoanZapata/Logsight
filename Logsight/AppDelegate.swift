import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // Setup entry point
        let fileLoader = FileLoaderImpl()
        let logsService = LogsServiceImpl(fileLoader: fileLoader)
        let mainViewModel = MainViewModel(logsService: logsService)
        window.contentViewController = MainViewController(viewModel: mainViewModel)
        
        // Reload previous apps if any
        logsService.startReadingPreviouslyAddedApplications()
    }
}
