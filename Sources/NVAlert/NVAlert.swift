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

    /**
     Configures the primary action button in the modal.
     */
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

    /**
     Configures a secondary button next to the primary button.

     Optional, and can be omitted if the condition is not met.
     */
    public func withSecondary(
        if condition: Bool = true,
        text: String,
        action: (@MainActor (NVAlertVC) -> Void)? = { vc in
            vc.close(with: .alertSecondButtonReturn)
        }
    ) -> Self {
        if !condition {
            return self
        }

        self.noticeVC.buttonSecondary.title = text
        self.noticeVC.actionSecondary = action
        return self
    }

    /**
     Configures a tertiary button on the left.
     Optional, and can be omitted if the condition is not met.
     If no text is set, a .helpButton is displayed instead.
     */
    public func withTertiary(
        if condition: Bool = true,
        text: String = "",
        action: (@MainActor (NVAlertVC) -> Void)? = nil
    ) -> Self {
        if !condition {
            return self
        }

        if text == "" {
            self.noticeVC.buttonTertiary.bezelStyle = .helpButton
        }

        self.noticeVC.buttonTertiary.title = text
        self.noticeVC.actionTertiary = action
        return self
    }

    /**
     Configures the text of the modal.
     */
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
     */
    @discardableResult
    @MainActor public func runModal(urgency: NVAlertUrgency) -> NSApplication.ModalResponse {
        let activationPolicy = NSApp.activationPolicy()

        if !Thread.isMainThread {
            assertionFailure("Alerts should always be presented on the main thread")
        }

        // Set the activation policy to .regular so we can see the icon
        if activationPolicy == .accessory {
            NSApp.setActivationPolicy(.regular)
        }

        // Should we request user attention?
        if urgency == .normalRequestAttention {
            NSApp.requestUserAttention(.informationalRequest)
        } else if urgency == .urgentRequestAttention {
            NSApp.requestUserAttention(.criticalRequest)
        } else if urgency == .bringToFront {
            NSApp.activate(ignoringOtherApps: true)
        }

        // Bring window to front
        guard let window = windowController.window else {
            fatalError("The window to display to NVAlert in is nil")
        }

        // Ensure the window is displayed in Mission Control
        window.collectionBehavior = [.participatesInCycle, .managed]

        // Ensure the window appears in front of others
        window.makeKeyAndOrderFront(nil)

        // Center the window
        window.setCenterPosition(offsetY: 70)

        // Finally, show the modal and wait for an outcome
        let response = NSApplication.shared.runModal(for: window)

        // If an outcome came but the window is not closed, close it
        windowController?.window?.close()

        // Revert the activation policy
        if activationPolicy == .accessory {
            NSApp.setActivationPolicy(.accessory)
        }

        return response
    }

    /** Shows the modal and returns true if the user pressed the primary button. */
    @MainActor public func didSelectPrimary(urgency: NVAlertUrgency) -> Bool {
        return self.runModal(urgency: urgency) == .alertFirstButtonReturn
    }

    /**
     Shows the modal, and returns nothing.
     */
    @MainActor public func show(urgency: NVAlertUrgency) {
        _ = self.runModal(urgency: urgency)
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
