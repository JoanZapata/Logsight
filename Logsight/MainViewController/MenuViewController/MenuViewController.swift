import Cocoa

class MenuViewController : NSViewController {
    
    let viewModel: ViewModel
    
    @IBOutlet weak var applicationStackView: NSStackView!
    @IBOutlet weak var logLevelStackView: NSStackView!
    
    private var applications: [Application: Bool] = [:]
    private var applicationViews: [ApplicationItemViewController] = []
    private var logLevelViews: [LevelItemViewController] = []
    
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
        updateLogLevels()
    }
    
    func updateLogLevels() {
        logLevelViews = []
        logLevelStackView.subviews = []
        LogLevel.allCases.forEach { level in
            let item = LevelItemViewController(delegate: self, level: level)
            logLevelViews.append(item)
            logLevelStackView.addArrangedSubview(item.view)
        }
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
        applicationViews = []
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

extension MenuViewController: LevelItemViewControllerDelegate {
 
    func onToggle(level: LogLevel, newValue checked: Bool) {
        viewModel.setLogLevelFilter(logLevels: logLevelViews
            .filter { $0.isChecked() }
            .map { $0.level })
    }
    
    func onSelected(level: LogLevel) {
        // TODO define log filter and call view model
        print("Selected \(level)")
    }
}
