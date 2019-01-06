import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // Setup entry point
        let fileLoader = FileLoaderImpl()
        let viewModel = ViewModel(fileLoader: fileLoader)
        window.contentViewController = MainViewController(viewModel: viewModel)
        
        // Reload previous apps if any
        viewModel.startReadingPreviouslyAddedApplications()
    }
}
