import Cocoa

class DropZone: NSView {
    
    var dropZoneDelegate: DropZoneDelegate? = nil
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        registerForDraggedTypes([NSPasteboard.PasteboardType.fileURL])
        wantsLayer = true
        layer!.borderColor = NSColor.darkGray.withAlphaComponent(0.2).cgColor
        layer!.borderWidth = 0
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        layer!.borderWidth = 10
        return NSDragOperation.link
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        layer?.borderWidth = 0
    }
    
    override func concludeDragOperation(_ sender: NSDraggingInfo?) {
        layer?.borderWidth = 0
    }
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        return dropZoneDelegate != nil
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let url = NSURL(from: sender.draggingPasteboard)?.filePathURL else { return false }
        dropZoneDelegate?.fileDropped(url: url)
        return true
    }
}

protocol DropZoneDelegate {
    
    func fileDropped(url: URL)
}
