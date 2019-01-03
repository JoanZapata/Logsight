import Cocoa

class MenuViewController : NSViewController {
    
    let viewModel: MenuViewModel
    
    @IBOutlet weak var applicationStackView: NSStackView!
    
    init(viewModel: MenuViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        viewModel.delegate = self
    }
}

extension MenuViewController : MenuViewModelDelegate {
    
    func onLogLevelsChange(logLevels: [String]) {
        // TODO
    }
    
    func onApplicationsChange(applications: [String]) {
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

        applications.forEach {
            let button = NSButton(checkboxWithTitle: $0, target: nil, action: nil)
            button.state = .on
            applicationStackView.addArrangedSubview(button)
        }
    }
}
