import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let fileLoader = FileLoaderImpl()
        let mainViewModel = MainViewModel(fileLoader: fileLoader)
        window.contentViewController = MainViewController(viewModel: mainViewModel)
    }
}
