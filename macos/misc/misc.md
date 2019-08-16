

## Show Alert modal

```
let alert = NSAlert.init()
alert.messageText = "Title"
alert.informativeText = "Info"
alert.alertStyle = NSAlertStyle.warning
alert.addButton(withTitle: "OK")
alert.addButton(withTitle: "Cancel")
alert.runModal()
```

## Show Alert modal & get answer

```
func showAlert(title t: String, message m: String) -> Bool {
    let alert = NSAlert.init()
    alert.messageText = t
    alert.informativeText = m
    alert.addButton(withTitle: "OK")
    alert.addButton(withTitle: "Cancel")
    return alert.runModal() == NSApplication.ModalResponse.alertFirstButtonReturn
}

...

let ok = showAlert(title: "title", message: "message")
if ok {
    ...
}
```

## Show User Notification

```
// global / class var
var notificationDelegate = NotificationDelegate()

...

func showNotification() {
    ....
let notification = NSUserNotification()
notification.identifier = NSUUID().uuidString
notification.title = currentTimerRunning!.name
notification.subtitle = currentTimerIntervalRunning!.name
//        notification.informativeText = "This is a test"
notification.soundName = NSUserNotificationDefaultSoundName
notification.hasActionButton = false // just display 'Close' button
//        notification.hasActionButton = true
//        notification.actionButtonTitle = "Ok"


NSUserNotificationCenter.default.delegate = notificationDelegate
NSUserNotificationCenter.default.deliver(notification)

}

...

class NotificationDelegate: NSObject, NSUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }

    // for custom actions / buttons
    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
    }
}

```

In **Info.plist**

set Key "NSUserNotificationAlertStyle" to Value "alert" -> to display buttons

All options: banner, alert, or none.

## Show Popover

```
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusBarItem: NSStatusItem?
    let menuPopover = NSPopover()
    var isPopoverVisible = false

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        guard let statusBarItem = statusBarItem else {
            print("Error! Status bar item cannot be created")
            NSApp.terminate(nil)
            return
        }

        guard let menuButton = statusBarItem.button else {
            print("Error! Status bar item cannot be created")
            NSApp.terminate(nil)
            return
        }

        menuButton.title = "\u{1F551}"

        menuButton.action = #selector(togglePopover)

        menuPopover.contentViewController = MenuViewController()

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @objc func togglePopover(_ sender: Any?) {
        if isPopoverVisible {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
        isPopoverVisible = !isPopoverVisible
    }

    func showPopover(sender: Any?) {
        if let button = statusBarItem?.button {
            menuPopover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }

    func closePopover(sender: Any?) {
        menuPopover.performClose(sender)
    }

}

class MenuViewController: NSViewController {

    let textField = NSTextField()
    let button = NSButton()

    override func loadView() {
        self.view = NSView(frame: NSRect(x: 0, y: 0, width: 300, height: 300))
    }

    override func viewDidLoad() {
       super.viewDidLoad()


        self.view.addSubview(textField)
        textField.isBezeled = false
        textField.drawsBackground = false
        textField.isEditable = false
        textField.isSelectable = false
        textField.stringValue = "TEST"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        textField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true

        button.title = "button"
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true

    }

}

```

![i1][img1]


[img1]: https://github.com/alexadam/swift-tutorials/raw/master/macos/misc/images/s1.png "s1"
