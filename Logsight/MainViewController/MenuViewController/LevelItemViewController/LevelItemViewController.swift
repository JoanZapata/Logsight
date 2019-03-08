import Cocoa

class LevelItemViewController: NSViewController {
    
    @IBOutlet weak var label: NSTextField!
    @IBOutlet weak var checkbox: NSButton!
    
    let delegate: LevelItemViewControllerDelegate
    let level: LogLevel
    
    init(delegate: LevelItemViewControllerDelegate, level: LogLevel) {
        self.delegate = delegate
        self.level = level
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        label.stringValue = level.rawValue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func onLabelTapped(_ sender: Any) {
        delegate.onSelected(level: level)
    }
    
    @IBAction func onCheckTapped(_ sender: Any) {
        delegate.onToggle(level: level, newValue: checkbox.state == .on)
    }
    
    func setValue(checked: Bool) {
        checkbox.state = .on
    }
    
    func isChecked() -> Bool {
        return checkbox.state == .on
    }
}

protocol LevelItemViewControllerDelegate {
    
    func onToggle(level: LogLevel, newValue checked: Bool)
    
    func onSelected(level: LogLevel)
}
