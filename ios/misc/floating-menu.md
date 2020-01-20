# Create a floating menu

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
        
    }
    
    @objc func importAction() {

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