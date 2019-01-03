import Cocoa

class MainViewController : NSViewController {
    
    private let menuMinWidth = 170
    private let viewModel: MainViewModel
    
    @IBOutlet weak var splitView: NSSplitView!
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        let menuVC = MenuViewController(viewModel: viewModel.menuViewModel)
        let logsVC = LogsViewController(viewModel: viewModel.logsViewModel)
        
        splitView.addArrangedSubview(menuVC.view)
        splitView.addArrangedSubview(logsVC.view)
        
        menuVC.view.widthAnchor
            .constraint(equalToConstant: CGFloat(menuMinWidth))
            .isActive = true
    }
}
