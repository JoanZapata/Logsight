import Cocoa

class MenuViewController : NSViewController {
    
    let viewModel: ViewModel
    
    @IBOutlet weak var applicationStackView: NSStackView!
    
    private var applications: [Application] = []
    private var applicationViews: [ApplicationItemViewController] = []
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        viewModel.addDelegate(self)
        updateApplications()
    }
}

extension MenuViewController : ViewModelDelegate {
    
    func onStartListening(toApplication application: Application) {
        self.applications.append(application)
        updateApplications()
    }
    
    func onStopListening(toApplication application: Application) {
        self.applications.removeAll(where: { $0.filePath == application.filePath })
        updateApplications()
    }
    
    func updateApplications() {
        applicationStackView.subviews = []
        if applications.isEmpty {
            let placeholder = NSTextField()
            placeholder.isEditable = false
            placeholder.drawsBackground = false
            placeholder.isBezeled = false
            placeholder.stringValue = "No application yet, drag a log file into the main panel."
            placeholder.lineBreakMode = .byWordWrapping
            applicationStackView.addArrangedSubview(placeholder)
            return
        }
        
        applications.forEach { app in
            let button = ApplicationItemViewController(delegate: self, application: app)
            
            applicationViews.append(button)
            applicationStackView.addArrangedSubview(button.view)
        }
    }
}

extension MenuViewController : ApplicationItemViewControllerDelegate {

    func onRemoveClicked(forApplication application: Application) {
        viewModel.stopReading(application: application)
    }
}
