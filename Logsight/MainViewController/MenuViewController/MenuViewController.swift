import Cocoa

class MenuViewController : NSViewController {
    
    let viewModel: ViewModel
    
    @IBOutlet weak var applicationStackView: NSStackView!
    
    private var applications: [Application: Bool] = [:]
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
        self.applications[application] = true
        updateApplications()
    }
    
    func onStopListening(toApplication application: Application) {
        self.applications.removeValue(forKey: application)
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
        
        applications.forEach { (app, enabled) in
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
    
    func onToggle(application: Application, newValue checked: Bool) {
        applications[application] = checked
        
        let checkedApplications = applications
            .filter { $0.value }
            .map { $0.key }
        viewModel.setApplicationFilter(applications: checkedApplications)
    }
}
