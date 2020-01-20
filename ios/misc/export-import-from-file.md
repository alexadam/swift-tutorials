# Export & Import from file

## Create a floating menu

In a ViewController add a Show Menu Button:

```
let settingsButton = UIButton()
        view.addSubview(settingsButton)
        settingsButton.setTitle("Settings", for: .normal)
        settingsButton.setTitleColor(.blue, for: .normal)
        settingsButton.titleLabel?.textAlignment = .center
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        settingsButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        settingsButton.addTarget(self, action: #selector(settingsAction), for: .touchDown)
```

then create the **settingsAction**:

```
@objc func settingsAction() {
        let settingsVC = SettingsMenuVC()
        settingsVC.modalTransitionStyle = .crossDissolve
        settingsVC.modalPresentationStyle = .overCurrentContext
        self.present(settingsVC, animated: true, completion: nil)
    }
```

## Add Imports

```
import MobileCoreServices
```

## Create the Menu View Controller

```
class SettingsMenuVC: UIViewController {
    
    let settingsMenu = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createLayout()
    }
    
    func createLayout() {

        let gestureSwift2AndHigher = UITapGestureRecognizer(target: self, action:  #selector (self.closeAction))
        view.addGestureRecognizer(gestureSwift2AndHigher)
        
        settingsMenu.backgroundColor = .white
        view.addSubview(settingsMenu)
        settingsMenu.translatesAutoresizingMaskIntoConstraints = false
        settingsMenu.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
        settingsMenu.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        settingsMenu.widthAnchor.constraint(equalToConstant: 100).isActive = true
        settingsMenu.heightAnchor.constraint(equalToConstant: 65).isActive = true

        settingsMenu.layer.cornerRadius = 5
        settingsMenu.layer.shadowColor = UIColor.black.cgColor
        settingsMenu.layer.shadowOpacity = 0.25
        settingsMenu.layer.shadowOffset = .zero
        settingsMenu.layer.shadowRadius = 6
        
        let exportButton = UIButton()
        settingsMenu.addSubview(exportButton)
        exportButton.setTitle("Export", for: .normal)
        exportButton.setTitleColor(.blue, for: .normal)
        exportButton.titleLabel?.textAlignment = .center
        exportButton.translatesAutoresizingMaskIntoConstraints = false
        exportButton.topAnchor.constraint(equalTo: settingsMenu.topAnchor, constant: 0).isActive = true
        exportButton.rightAnchor.constraint(equalTo: settingsMenu.rightAnchor, constant: 0).isActive = true
        exportButton.leftAnchor.constraint(equalTo: settingsMenu.leftAnchor, constant: 0).isActive = true
        exportButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        exportButton.addTarget(self, action: #selector(exportAction), for: .touchDown)
        
        let importButton = UIButton()
        settingsMenu.addSubview(importButton)
        importButton.setTitle("Import", for: .normal)
        importButton.setTitleColor(.blue, for: .normal)
        importButton.titleLabel?.textAlignment = .center
        importButton.translatesAutoresizingMaskIntoConstraints = false
        importButton.topAnchor.constraint(equalTo: exportButton.bottomAnchor, constant: 0).isActive = true
        importButton.rightAnchor.constraint(equalTo: settingsMenu.rightAnchor, constant: 0).isActive = true
        importButton.leftAnchor.constraint(equalTo: settingsMenu.leftAnchor, constant: 0).isActive = true
        importButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        importButton.addTarget(self, action: #selector(importAction), for: .touchDown)
    }
    
    @objc func exportAction() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeFolder)],
                                                            in: .open) // .import
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false

        self.present(documentPicker, animated: true)
    }
    
    @objc func importAction() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [
            String(kUTTypeText),
            String(kUTTypeContent),String(kUTTypeItem),
            String(kUTTypeData)
            ],
        in: .open) // .import
        
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        
        self.present(documentPicker, animated: true)
    }
    

    /// ?? - remove
    @objc func settingsAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func closeAction() {
        dismiss(animated: true, completion: nil)
    }
}

```

## Implement the Document Picker Delegate

```
extension SettingsMenuVC: UIDocumentPickerDelegate {

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        let file = "take-a-break." + getTimeStamp() + ".json"        
        var isDirectory = false
        
        do {
            isDirectory = (try urls[0].resourceValues(forKeys: [.isDirectoryKey])).isDirectory!
        } catch {
            print(error)
        }
        
        if !isDirectory {
            let fileURL = urls[0]
            do {
                let jsonString = try String(contentsOf: fileURL, encoding: .utf8)
                DataManager.shared.fromJsonString(jsonString: jsonString)
                parentVC!.reloadTimePatternStackView()
            }
            catch {
                print("Failed reading from file: \(fileURL), Error: " + error.localizedDescription)
            }
        } else {
            let fileURL = urls[0].appendingPathComponent(file)
            do {
                let jsonString = DataManager.shared.toJsonString()
                try jsonString.write(to: fileURL, atomically: false, encoding: .utf8)
            }
            catch {
                print("Failed writing to file: \(fileURL), Error: " + error.localizedDescription)
            }
        }
        
        closeAction()
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        closeAction()
    }
    
    func getTimeStamp() -> String {
        let now = Date()
        let formatter = DateFormatter()

        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yy-MM-dd-HH-mm"

        return formatter.string(from: now)
    }
}

```

# Misc - create an export action (to other apps) - with ActivityViewController

## Create a custom Document:

```
//class JsonDataDoc: UIDocument {
//
//    var content: String = "test string"
//
//    override func contents(forType typeName: String) throws -> Any {
//        // Encode your document with an instance of NSData or NSFileWrapper
//        return content.data(using: .utf8)
//    }
//
//    override func load(fromContents contents: Any, ofType typeName: String?) throws {
//        //    if let json = contents as? Data{
//        if let json = contents as? String{
//            content = json
//        } else {
//            print("Error trying to load NumberCards. Content is not JSON data")
//        }
//    }
//}
```

## In some 'export' button's action:

```
//        let temporaryURL = URL(fileURLWithPath: NSTemporaryDirectory() + "test.doc.json")
//        let testDocument = JsonDataDoc(fileURL: temporaryURL)
////        testDocument.load(recipe: recipe)
//
//
//        testDocument.save(to: temporaryURL, for: .forCreating, completionHandler: { success in
//            guard success else { return }
//            // Pass URL to UIActivityViewController
//            let activityViewController = UIActivityViewController(activityItems: [temporaryURL], applicationActivities: nil)
//            DispatchQueue.main.async {
//                self.present(activityViewController, animated: true, completion: nil)
//            }
//        })
```