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
        print("toggleAlwaysOnTop")
        if let (win, info) = getActiveWindowExtra() {
            print("info: \(info)")
            let value = isAlwaysOnTop(win)
            let newValue = !value
            let err = AXUIElementSetAttributeValue(
                win, "AXSubrole" as CFString,
                newValue ? "AXSystemFloatingWindow" as CFTypeRef : "" as CFTypeRef)
            if err == .success {
                print("Always on top state changed to: \(newValue)")
            } else {
                print("Failed to change state: \(err)")
            }
        } else {
            print("No active window found")
        }
    }

    func isAlwaysOnTop(_ window: AXUIElement) -> Bool {
        var value: AnyObject?
        let err = AXUIElementCopyAttributeValue(window, "AXSubrole" as CFString, &value)
        if err != .success {
            print("could not get ax subrole: \(err)")
        }
        if err == .success, let subrole = value as? String {
            print("subrole: \(subrole)")
            return subrole == "AXSystemFloatingWindow"
        }
        return false
    }

    func getActiveWindowExtra() -> (AXUIElement, String)? {
        let systemWideElement = AXUIElementCreateSystemWide()

        var activeApp: AnyObject?
        let error = AXUIElementCopyAttributeValue(
            systemWideElement, kAXFocusedApplicationAttribute as CFString, &activeApp)

        guard error == .success else {
            print("Error getting active application: \(error)")
            return nil
        }

        var appName: CFTypeRef?
        AXUIElementCopyAttributeValue(
            activeApp as! AXUIElement, kAXTitleAttribute as CFString, &appName)
        let applicationName = (appName as? String) ?? "Unknown"

        var focusedWindow: AnyObject?
        let windowError = AXUIElementCopyAttributeValue(
            activeApp as! AXUIElement, kAXFocusedWindowAttribute as CFString, &focusedWindow)

        guard windowError == .success, let window = focusedWindow else {
            print("Error getting focused window: \(windowError)")
            return nil
        }

        var windowTitle: CFTypeRef?
        AXUIElementCopyAttributeValue(
            window as! AXUIElement, kAXTitleAttribute as CFString, &windowTitle)
        let title = (windowTitle as? String) ?? "Unknown"

        return ((window as! AXUIElement), "\(applicationName): \(title)")
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
