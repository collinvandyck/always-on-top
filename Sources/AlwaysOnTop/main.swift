import ApplicationServices
import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem.button {
            button.image = NSImage(
                systemSymbolName: "pin", accessibilityDescription: "Toggle Always on Top")
        }

        setupMenu()
        checkAccessibilityPermissions()
    }

    func setupMenu() {
        let menu = NSMenu()
        menu.addItem(
            NSMenuItem(
                title: "Toggle Always on Top", action: #selector(toggleAlwaysOnTop),
                keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(
            NSMenuItem(
                title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        statusItem.menu = menu
    }

    @objc func toggleAlwaysOnTop() {
        if let window = getActiveWindow() {
            var title: CFTypeRef?
            AXUIElementCopyAttributeValue(window, kAXTitleAttribute as CFString, &title)
            if let windowTitle = title as? String {
                print("Active window: \(windowTitle)")
                // Note: You can't directly set window.level for AXUIElement
                // You'll need to use a different approach to set "always on top"
            } else {
                print("Active window found, but couldn't get title")
            }
        } else {
            print("No active window found")
        }
    }

    func getActiveWindow() -> AXUIElement? {
        let systemWideElement = AXUIElementCreateSystemWide()

        var activeApp: AnyObject?
        let error = AXUIElementCopyAttributeValue(
            systemWideElement, kAXFocusedApplicationAttribute as CFString, &activeApp)

        guard error == .success else {
            print("Error getting active application: \(error)")
            return nil
        }

        var focusedWindow: AnyObject?
        let windowError = AXUIElementCopyAttributeValue(
            activeApp as! AXUIElement, kAXFocusedWindowAttribute as CFString, &focusedWindow)

        guard windowError == .success, let window = focusedWindow else {
            print("Error getting focused window: \(windowError)")
            return nil
        }

        return (window as! AXUIElement)
    }

    func checkAccessibilityPermissions() {
        let options: NSDictionary = [
            kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true
        ]
        let accessibilityEnabled = AXIsProcessTrustedWithOptions(options)

        if !accessibilityEnabled {
            print("Accessibility permissions are required for this app to function properly.")
        }
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
