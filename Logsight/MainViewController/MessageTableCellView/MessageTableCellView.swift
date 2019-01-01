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
        dot.color = lineColor(for: logLevel).cgColor
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

    private func lineColor(for level: LogLevel) -> NSColor {
        switch level {
            case .trace: return NSColor.init(rgb: 0xC4C4C4)
            case .debug: return NSColor.init(rgb: 0xC4C4C4)
            case .info: return NSColor.init(rgb: 0xA4CBE1)
            case .warn: return NSColor.init(rgb: 0xE5B468)
            case .error: return NSColor.init(rgb: 0xD35E53)
        }
    }
}

extension NSColor {
    convenience init(rgb: Int, alpha: Float = 1.0) {
        self.init(
            red: CGFloat((rgb >> 16) & 0xFF) / 255.0,
            green: CGFloat((rgb >> 8) & 0xFF) / 255.0,
            blue: CGFloat(rgb & 0xFF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}
