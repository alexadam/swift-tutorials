# Create a Menu Bar (Status Bar) App

## Simple Menu app

in **AppDelegate.swift**:

```
import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusBarItem.button?.title = "\u{1F551}"

        statusBarItem.menu = NSMenu()

        let menuItem = NSMenuItem(title: "Menu...", action: #selector(displayMenu), keyEquivalent: "")

        statusBarItem.menu?.addItem(menuItem)

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @objc func displayMenu(_ sender: NSMenuItem) {
        let alert = NSAlert.init()
        alert.messageText = "Title"
        alert.informativeText = "Info"
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        alert.runModal()
    }
}
```

![i1][img1]


## Dynamically add icons (actions) to menu bar

```
import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var allStatusItems: [NSStatusItem] = []

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusBarItem.button?.title = "\u{1F551}"

        statusBarItem.menu = NSMenu()

        let menuItem = NSMenuItem(title: "Add Toolbar Item...", action: #selector(addToolbarItem), keyEquivalent: "")

        statusBarItem.menu?.addItem(menuItem)

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @objc func addToolbarItem(_ sender: NSMenuItem) {

        let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusBarItem.button?.title = "Dyn \(allStatusItems.count + 1)"
        statusBarItem.button?.action = #selector(dynamicAction)

        statusBarItem.button?.bezelStyle = NSButton.BezelStyle.texturedSquare
        statusBarItem.button?.isBordered = false
        statusBarItem.button?.wantsLayer = true
        statusBarItem.button?.layer?.backgroundColor = NSColor.yellow.cgColor

        statusBarItem.button?.contentTintColor = NSColor.red
        allStatusItems.append(statusBarItem)
    }

    @objc func dynamicAction(_ sender: NSStatusBarButton) {
        let alert = NSAlert.init()
        alert.messageText = "Sent from: \(sender.title)"
        alert.informativeText = "Info"
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        alert.runModal()
    }

}
```

![i2][img2]


[img1]: https://github.com/alexadam/swift-tutorials/raw/master/macos/main-menu-bar-app/images/s1.png "s1"
[img2]: https://github.com/alexadam/swift-tutorials/raw/master/macos/main-menu-bar-app/images/s2.png "s2"
