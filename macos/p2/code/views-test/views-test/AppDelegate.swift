
import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    let windowController = MainWindowController()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        windowController.showWindow(self)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

}


