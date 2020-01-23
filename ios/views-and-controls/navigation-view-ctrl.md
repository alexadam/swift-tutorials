# UINavigationController

After the empty project setup, in **SceneDelegate.swift**:

```
func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        let nc = UINavigationController(rootViewController: NavViewController())
        window?.rootViewController = nc
        window?.makeKeyAndVisible()
    }
```

Create **NavViewController.swift**

```
import UIKit


class NavViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .yellow
        
        let openNextPage = UIButton()
        openNextPage.backgroundColor = .white
        openNextPage.setTitleColor(.black, for: .normal)
        openNextPage.setTitle("Open Page 1", for: .normal)
        view.addSubview(openNextPage)
        openNextPage.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        openNextPage.addTarget(self, action: #selector(goToNextViewAction), for: .touchDown)
    }
    
    @objc func goToNextViewAction() {
        navigationController?.pushViewController(NavPage1VC(), animated: true)
    }
}


class NavPage1VC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        navigationItem.title = "page 1"

        let openNextPage = UIButton()
        openNextPage.backgroundColor = .white
        openNextPage.setTitleColor(.black, for: .normal)
        openNextPage.setTitle("Open Page 2", for: .normal)
        view.addSubview(openNextPage)
        openNextPage.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        openNextPage.addTarget(self, action: #selector(goToNextViewAction), for: .touchDown)
    }
    
    @objc func goToNextViewAction() {
        navigationController?.pushViewController(NavPage2VC(), animated: true)
    }
}

class NavPage2VC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        
        navigationItem.title = "page 2"
        
        let openNextPage = UIButton()
        openNextPage.backgroundColor = .white
        openNextPage.setTitleColor(.black, for: .normal)
        openNextPage.setTitle("Open Page 3", for: .normal)
        view.addSubview(openNextPage)
        openNextPage.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        openNextPage.addTarget(self, action: #selector(goToNextViewAction), for: .touchDown)
    }
    
    @objc func goToNextViewAction() {
        navigationController?.pushViewController(NavPage3VC(), animated: true)
    }
}

class NavPage3VC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
        navigationItem.title = "page 3"
//        navigationController?.isToolbarHidden = true
        
        let leftBarButtonItem: UIBarButtonItem = {
            let barButtonItem = UIBarButtonItem(title: "<<< Left Item", style: .plain, target: self, action: #selector(goBackAction))
            barButtonItem.tintColor = UIColor.red
            return barButtonItem
        }()
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
//        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        
//        // back
//        navigationController?.popViewController(animated: true)
//        // reset
//        navigationController?.popToRootViewController(animated: true)
        
    }
    
    @objc func goBackAction() {
        navigationController?.popViewController(animated: true)
    }
    
}
```