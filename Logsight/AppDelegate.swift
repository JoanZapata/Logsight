import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // Setup entry point
        let fileLoader = FileLoaderImpl()
        let viewModel = ViewModel(fileLoader: fileLoader)
        window.contentViewController = MainViewController(viewModel: viewModel)
        
        // Add the window itself as a delegate to the view model
        viewModel.addDelegate(self)
        
        // Reload previous apps if any
        viewModel.startReadingPreviouslyAddedApplications()
    }
}

extension AppDelegate: ViewModelDelegate {
    func onCountersChanged(counters: Counters) {
        window.title = "\(counters.totalLogs) logs"
    }
}
