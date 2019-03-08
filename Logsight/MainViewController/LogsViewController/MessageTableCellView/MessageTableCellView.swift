import Cocoa

class MessageTableCellView: NSTableCellView {
    
    @IBOutlet private weak var label: NSTextField!
    @IBOutlet private weak var dot: LogLevelDot!
    
    func setup(text: String, logLevel: LogLevel, columnWidth: CGFloat) {
        label.stringValue = text
        
        // We have to use the column width here because autolayout seems to trap itself
        // at the cell level: the cell follows the size of the text, which grows with it
        // but then it doesn't shrink as expected when the window is resized down.
        updateLabelWidth(withContainerWidth: columnWidth)
        dot.color = logLevel.color().cgColor
    }
    
    override func viewDidEndLiveResize() {
        updateLabelWidth(withContainerWidth: self.frame.width)
    }
    
    private func updateLabelWidth(withContainerWidth containerWidth: CGFloat) {
        // For some reason I don't fully understand, if the preferred width and the actual
        // fixed width of the label get out of sync the text field sometimes fails to
        // compute it's height.
        let expectedWidth = containerWidth - label.frame.origin.x
        label.preferredMaxLayoutWidth = expectedWidth
        label.widthAnchor.constraint(equalToConstant: expectedWidth)
    }
}
