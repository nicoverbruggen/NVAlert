import Foundation
import Cocoa

extension NSWindow {
    /** Centers a window. Taken from: https://stackoverflow.com/a/66140320 */
    public func setCenterPosition(offsetY: CGFloat = 0) {
        if let screenSize = screen?.visibleFrame.size {
            self.setFrameOrigin(
                NSPoint(
                    x: (screenSize.width - frame.size.width) / 2,
                    y: (screenSize.height - frame.size.height) / 2 + offsetY
                )
            )
        }
    }
}
