import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    var isAlwaysOnTop = false

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the window
        let windowRect = NSRect(x: 100, y: 100, width: 300, height: 200)
        window = NSWindow(
            contentRect: windowRect, styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered, defer: false)
        window.title = "Toggle Always on Top"
        window.makeKeyAndOrderFront(nil)

        // Create a button
        let button = NSButton(frame: NSRect(x: 0, y: 0, width: 200, height: 40))
        button.title = "Toggle Always on Top"
        button.bezelStyle = .rounded
        button.target = self
        button.action = #selector(toggleAlwaysOnTop)

        // Center the button in the window
        button.frame.origin = NSPoint(
            x: (window.contentView!.frame.width - button.frame.width) / 2,
            y: (window.contentView!.frame.height - button.frame.height) / 2
        )

        // Add the button to the window
        window.contentView?.addSubview(button)
    }

    @objc func toggleAlwaysOnTop() {
        isAlwaysOnTop.toggle()
        if isAlwaysOnTop {
            window.level = .floating
            print("Window is now always on top")
        } else {
            window.level = .normal
            print("Window is no longer always on top")
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

// Create and run the application
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
