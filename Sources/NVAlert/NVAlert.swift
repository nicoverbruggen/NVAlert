import Foundation
import Cocoa

@MainActor
open class NVAlert {

    var windowController: NSWindowController!

    var noticeVC: NVAlertVC {
        return self.windowController.contentViewController as! NVAlertVC
    }

    public init() {
        let storyboard = NSStoryboard(name: "NVAlert", bundle: Bundle.module)

        self.windowController = storyboard.instantiateController(
            withIdentifier: "window"
        ) as? NSWindowController
    }

    public static func make() -> NVAlert {
        return NVAlert()
    }

    public func withPrimary(
        text: String,
        action: @MainActor @escaping (NVAlertVC) -> Void = { vc in
            vc.close(with: .alertFirstButtonReturn)
        }
    ) -> Self {
        self.noticeVC.buttonPrimary.title = text
        self.noticeVC.actionPrimary = action
        return self
    }

    public func withSecondary(
        text: String,
        action: (@MainActor (NVAlertVC) -> Void)? = { vc in
            vc.close(with: .alertSecondButtonReturn)
        }
    ) -> Self {
        self.noticeVC.buttonSecondary.title = text
        self.noticeVC.actionSecondary = action
        return self
    }

    public func withTertiary(
        text: String = "",
        action: (@MainActor (NVAlertVC) -> Void)? = nil
    ) -> Self {
        if text == "" {
            self.noticeVC.buttonTertiary.bezelStyle = .helpButton
        }
        self.noticeVC.buttonTertiary.title = text
        self.noticeVC.actionTertiary = action
        return self
    }

    public func withInformation(
        title: String,
        subtitle: String,
        description: String = ""
    ) -> Self {
        self.noticeVC.labelTitle.stringValue = title
        self.noticeVC.labelSubtitle.stringValue = subtitle
        self.noticeVC.labelDescription.stringValue = description

        // If the description is missing, handle the excess space and change the top margin
        if description == "" {
            self.noticeVC.labelDescription.isHidden = true
            self.noticeVC.primaryButtonTopMargin.constant = 0
        }
        return self
    }

    /**
     Shows the modal and returns a ModalResponse.
     If you wish to simply show the alert and disregard the outcome, use `show`.
     */
    @MainActor public func runModal() -> NSApplication.ModalResponse {
        if !Thread.isMainThread {
            assertionFailure("Alerts should always be presented on the main thread")
        }

        NSApp.activate(ignoringOtherApps: true)

        windowController.window?.makeKeyAndOrderFront(nil)
        windowController.window?.setCenterPosition(offsetY: 70)
        return NSApplication.shared.runModal(for: windowController.window!)
    }

    /** Shows the modal and returns true if the user pressed the primary button. */
    @MainActor public func didSelectPrimary() -> Bool {
        return self.runModal() == .alertFirstButtonReturn
    }

    /**
     Shows the modal and does not return anything.
     */
    @MainActor public func show() {
        _ = self.runModal()
    }

    /**
     Shows the modal attached as a sheet to a given window.
     Also gives you access to a completion handler to tackle the outcome of the modal.
     */
    @MainActor public func presentAsSheet(
        attachedTo parentWindow: NSWindow,
        completionHandler: ((NSApplication.ModalResponse) -> Void)? = nil
    ) {
        guard let alertWindow = windowController.window else {
            assertionFailure("Alert window not available")
            return
        }

        parentWindow.makeKeyAndOrderFront(nil)
        parentWindow.beginSheet(alertWindow) { response in
            completionHandler?(response)
        }
    }
}
