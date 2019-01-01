import Cocoa

class LogLevelDot: NSView {
    
    var color: CGColor = CGColor.black {
        didSet {
            layer!.backgroundColor = color
        }
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        wantsLayer = true
        layer!.backgroundColor = color
        layer!.cornerRadius = 2
    }
}
