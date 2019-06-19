# Misc

## Change View / ViewController

```
let svc = SecondViewController()

// optional
svc.modalPresentationStyle = .overCurrentContext

self.parentViewController.present(svc, animated: true, completion: nil)
// OR
self.present(ViewController(), animated: true, completion: nil)
```

## Swipe action on table cell

```
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let TrashAction = UIContextualAction(style: .normal, title:  "Trash", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Update action ...")
            success(true)
        })
        TrashAction.backgroundColor = .red

        // Write action code for the Flag
        let FlagAction = UIContextualAction(style: .normal, title:  "Flag", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Update action ...")
            success(true)
        })
        FlagAction.backgroundColor = .orange

        // Write action code for the More
        let MoreAction = UIContextualAction(style: .normal, title:  "More", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Update action ...")
            success(true)
        })
        MoreAction.backgroundColor = .gray


        return UISwipeActionsConfiguration(actions: [TrashAction, FlagAction, MoreAction])
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) ->                UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            print("index path of delete: \(indexPath)")
            completionHandler(true)
        }

        let rename = UIContextualAction(style: .normal, title: "Edit") { (action, sourceView, completionHandler) in
            print("index path of edit: \(indexPath)")
            completionHandler(true)
        }
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [rename, delete])


        ////// !!!
        swipeActionConfig.performsFirstActionWithFullSwipe = false

        return swipeActionConfig

    }

    /// ??
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

```

## Get size of text based on font's type & size

```
    let word = "word"
    let font = UIFont(name: "Helvetica", size: 30)
    let size = word.size(withAttributes:[.font: font])
    // size.width, size.height

    // OR
    let size = text.size(withAttributes:[.font: UIFont.systemFont(ofSize:18.0)])

```

## Add Borders to Text Label

```
    /* src https://gist.github.com/MrJackdaw/6ffbc33fc274838412bfe3ad48592b9b
    switch side {
        case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
        case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
        case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
        case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
    }
    /*


    var label: UILabel!

    let border = CALayer()
    border.backgroundColor = UIColor.blue.cgColor
    border.frame = CGRect(x: contentView.frame.minX, y: contentView.frame.maxY, width: contentView.frame.width, height: 3)
    label.layer.addSublayer(border)
```

## Use CocoaPods

### How to install it: https://cocoapods.org/

### Go to the project folder and execute this command in the terminal:

```
pod init
```

### Add Dependencies

```
pod 'Alamofire', '~> 5.0.0-beta.5'
pod 'SwiftSoup'
```

in the Podfile Podfile

```
# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'ios-web-scraper' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ios-web-scraper
  pod 'Alamofire', '~> 5.0.0-beta.5'
  pod 'SwiftSoup'

end
```

### Install Dependencies

```
pod install
```

Then, open the **....xcworkspace** file generated in the project directory

### Uninstall Dependencies:

```
pod deintegrate
```


## Create a button & on 'click' event

```
// Declare the button
let requestButton = UIButton()
view.addSubview(requestButton)
requestButton.setTitle("request", for: .normal)
requestButton.backgroundColor = .blue

requestButton.addTarget(self, action: #selector(onNewRequest), for: .touchUpInside)

// create handler function

@objc func onNewRequest(_ sender: AnyObject?) {

}

```

## How to test app on iPhone

src: https://codewithchris.com/deploy-your-app-on-an-iphone/

### Connect you iPhone to the laptop

Then, go to Xcode -> Preferences... -> Accounts -> click on '+' (bottom, left)

then, select 'Apple ID' -> use your apple id...

then, click on 'Manage Certificates' -> click on '+' -> select 'iOS Development'

then, click on Project's root (config) -> go to Signing -> Team -> select '... Personal Team'

then, select you phone from the top bar/menu

+ IMPORTANT

https://stackoverflow.com/questions/46774005/codesign-wants-to-access-key-access-in-your-keychain-i-put-in-my-login-passwo/51201660

when it asks for password, use you User's password and click on 'Always Allow'

-> When you connect your phone, make sure it's unlocked

in Xcode, go to: Window -> Devices and Simulators and wait for the phone to be recognized


### misc troubleshooting

src: https://stackoverflow.com/questions/2160299/error-the-service-is-invalid

-> if it does not work, with the error "The service is invalid - Please check your setup and try again" or "PhaseScriptExecution failed with a nonzero exit code"

1. Try to delete the folder(s) related to your app at "~/Library/Developer/Xcode/DerivedData/YOUR_PROJECT-xyz..."

2. Run 'pod deintegrate' followed by 'pod intall'

3. in Xcode, go to Product -> Clean Build Folder

4. Restart Xcode

5. Restart iPhone

6. Delete the .app from iOS device/IPhone

-> When you connect your phone, make sure it's unlocked

in Xcode, go to: Window -> Devices and Simulators and wait for the phone to be recognized

-> trust app developer:

Go to: Settings -> general -> device management -> developer app -> click on "Trust ID"

-> Reset "Trust this computer"

Go to: Settings -> General -> Reset -> Reset Location and Privacy

## Draw rectangle on image

```
func drawRectangleOnImage(image: UIImage, secondRect: Bool = false) -> UIImage {
    let imageSize = image.size
    let scale: CGFloat = 0
    UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)
    let context = UIGraphicsGetCurrentContext()

    image.draw(at: CGPoint.zero)

    var rectangle = CGRect(x: 0, y: 400, width: imageSize.width, height: imageSize.height)
    if (secondRect) {
      rectangle = CGRect(x: 2500, y: 0, width: imageSize.width, height: imageSize.height)
    }

    context?.setFillColor(UIColor.black.cgColor)
    context?.addRect(rectangle)
    context?.drawPath(using: .fill)

    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage!
}
```


## ImagePicker Overlay

```
let imagePicker = UIImagePickerController()
imagePicker.delegate = self
imagePicker.sourceType = .camera
imagePicker.mediaTypes = [kUTTypeImage as String]

          let overlay = UIView()
          let frameA = imagePicker.cameraOverlayView!.frame
          overlay.frame = CGRect(x: 0, y: 0, width: frameA.width, height: frameA.height-100)

          let topMask = UILabel()
          overlay.addSubview(topMask)
          topMask.frame = CGRect(x: 0, y: 0, width: overlay.frame.width, height: 300)
          topMask.backgroundColor = .black

          let bottomMask = UILabel()
          overlay.addSubview(bottomMask)
          bottomMask.translatesAutoresizingMaskIntoConstraints = false
          bottomMask.topAnchor.constraint(equalTo: overlay.topAnchor, constant: 200).isActive = true
          bottomMask.bottomAnchor.constraint(equalTo: overlay.bottomAnchor, constant: 0).isActive = true
          bottomMask.leadingAnchor.constraint(equalTo: overlay.leadingAnchor, constant: 0).isActive = true
          bottomMask.trailingAnchor.constraint(equalTo: overlay.trailingAnchor, constant: 0).isActive = true
//          bottomMask.frame = CGRect(x: 0, y: 400, width: overlay.frame.width, height: 100)
          bottomMask.backgroundColor = .black

          imagePicker.cameraOverlayView = overlay
```

## set ScrollView scroll position

```
scrollView.setContentOffset(CGPoint(x: 0, y: 800), animated: true)
```

## WebView

```
let webView = WKWebView()

let url = URL(string: "https://www.google.ro/search?q=weather+cluj")!
webView.load(URLRequest(url: url))

webView.navigationDelegate = self

.... // WKNavigationDelegate delegate

func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    print("did start")
    self.timeOut = Timer.scheduledTimer(timeInterval: 7.0, target: self, selector: Selector(("cancelWeb")), userInfo: nil, repeats: false)
}

func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    print("did finish")
    self.timeOut.invalidate()
}


```


## Text field with Int/Float numbers input

```
tmpNrInput.keyboardType = .asciiCapableNumberPad
tmpNrInput.keyboardType = .decimalPad
```


## Modal Pop-up

```
class ModalPopUp: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        createLayout()
    }

    func createLayout() {

       view.backgroundColor = .init(displayP3Red: 0, green: 0, blue: 0, alpha: 0)

       // close if tap on background
       let bgView = UIView()
       view.addSubview(bgView)
       bgView.frame = view.frame
       bgView.backgroundColor = .init(displayP3Red: 0, green: 0, blue: 0, alpha: 0.5)
       let gesture = UITapGestureRecognizer(target: self, action: #selector(closePopUp))
       bgView.addGestureRecognizer(gesture)

       /// add more controls
   }

   @objc func closePopUp(_ sender: UIButton) {
       //        self.present(ViewController(), animated: true, completion: nil)
       self.dismiss(animated: true, completion: nil)
   }
}

////
// how to present it

let svc = ModalPopUp()
svc.modalPresentationStyle = .overCurrentContext
self.present(svc, animated: true, completion: nil)
```

## Custom Picker

```
class IntNrPicker: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    let pickerView = UIPickerView()
    let pickerData = Array(1...100)

    override func addContent() {
        pickerView.delegate = self
        pickerView.dataSource = self

        popUpView.addSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.topAnchor.constraint(equalTo: tmpNrInput.bottomAnchor, constant: 10).isActive = true
        pickerView.leadingAnchor.constraint(equalTo: popUpView.leadingAnchor, constant: 10).isActive = true
        pickerView.trailingAnchor.constraint(equalTo: popUpView.trailingAnchor, constant: -10).isActive = true
        pickerView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(pickerData[row])
    }

}

```
