import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let mainViewModel = LogsViewModel()
        window.contentViewController = LogsViewController(viewModel: mainViewModel)
    }
}
