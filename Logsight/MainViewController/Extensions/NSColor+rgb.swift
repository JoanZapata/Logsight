import Cocoa

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
