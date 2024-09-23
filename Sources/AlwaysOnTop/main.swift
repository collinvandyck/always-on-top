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
            let isAlwaysOnTop = window.level == .floating
            window.level = isAlwaysOnTop ? .normal : .floating
            print("Always on top: \(!isAlwaysOnTop)")
        } else {
            print("no active window just yet")
        }
    }

    func getActiveWindow() -> NSWindow? {
        // Implement logic to get the active window
        // This will require additional permissions and possibly private APIs
        return nil
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
