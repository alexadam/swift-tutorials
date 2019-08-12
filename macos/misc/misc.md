

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
