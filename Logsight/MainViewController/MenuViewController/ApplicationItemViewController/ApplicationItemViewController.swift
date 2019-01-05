import Cocoa

class ApplicationItemViewController: NSViewController {
    
    @IBOutlet weak var check: NSButton!
    
    private let delegate: ApplicationItemViewControllerDelegate
    private let application: Application
    
    init(delegate: ApplicationItemViewControllerDelegate, application: Application) {
        self.delegate = delegate
        self.application = application
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        check.title = application.name
        check.toolTip = application.filePath
    }
    
    @IBAction func onDeleteTapped(_ sender: Any) {
        delegate.onRemoveClicked(forApplication: application)
    }
}

protocol ApplicationItemViewControllerDelegate {
    
    func onRemoveClicked(forApplication application: Application)
}
