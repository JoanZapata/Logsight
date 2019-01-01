import Cocoa

class LogsViewController : NSViewController {
    
    private static let dateFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium
        return dateFormatter
    }()
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var dropZone: DropZone!
    
    let viewModel: LogsViewModel
    
    init(viewModel: LogsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        dropZone.dropZoneDelegate = self
        viewModel.delegate = self
    }
}

extension LogsViewController : MainViewModelDelegate {
    
    func logsDidUpdate(update: LogsUpdate) {
        let lastVisibleRow = tableView.rows(in: tableView.visibleRect).upperBound
        let shouldScrollToEndAfterUpdate = lastVisibleRow >= tableView.numberOfRows - 1
        
        switch update {
        case .added(let indexes):
            let range: CountableRange<IndexSet.Element> = indexes
            tableView.beginUpdates()
            tableView.insertRows(at: IndexSet(integersIn: range), withAnimation: .effectGap)
            tableView.endUpdates()
        }
        
        if shouldScrollToEndAfterUpdate {
            tableView.scrollToEndOfDocument(nil)
        }
    }
}

extension LogsViewController : DropZoneDelegate {
    
    func fileDropped(url: URL) {
        viewModel.loadNewFile(url: url)
    }
}

extension LogsViewController: NSTableViewDataSource, NSTableViewDelegate {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return viewModel.logs.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let columnIdentifier = tableColumn?.identifier else { return nil }
        let column = columnIdentifier.rawValue
        let item = viewModel.logs[row]
        let columnWidth = tableColumn!.width
        
        guard let cell = tableView.makeView(withIdentifier: columnIdentifier, owner: nil) as? NSTableCellView else { return nil }
        
        switch column {
        case "__date": cell.textField?.stringValue = LogsViewController.dateFormatter.string(from: item.date)
        case "__app": cell.textField?.stringValue = item.appName
        case "__message": (cell as! MessageTableCellView).setup(text: item.message, logLevel: item.level, columnWidth: columnWidth)
        default: cell.textField?.stringValue = item.data[column]!
        }
        
        return cell
    }
}
