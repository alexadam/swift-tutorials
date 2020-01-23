# Create UITabBar + animations

## After the project setup:

in **ViewController.swift**

```
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .yellow
        
        let goToTabBarView = UIButton()
        goToTabBarView.backgroundColor = .white
        goToTabBarView.setTitleColor(.black, for: .normal)
        goToTabBarView.setTitle("Open Tab Bar View", for: .normal)
        view.addSubview(goToTabBarView)
        goToTabBarView.translatesAutoresizingMaskIntoConstraints = false
        goToTabBarView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        goToTabBarView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 100).isActive = true
        goToTabBarView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        goToTabBarView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        goToTabBarView.addTarget(self, action: #selector(goToTabBarViewAction), for: .touchDown)
    }
    
    @objc func goToTabBarViewAction() {
        let tab1 = Page1VC()
        let tab1Item = UITabBarItem()
        tab1Item.title = "Tab 1"
//        tab1Item.image = UIImage(named: "home_icon")
        tab1.tabBarItem = tab1Item
        
        let tab2 = Page2VC()
        let tab2Item = UITabBarItem()
        tab2Item.title = "Tab 2"
        tab2Item.image = .remove
        tab2.tabBarItem = tab2Item
        
        let tab3 = Page3VC()
        let tab3Item = UITabBarItem()
        tab3Item.title = "Tab 3"
        tab3.tabBarItem = tab3Item
               
        let tabBarVC = TabBarController()
        tabBarVC.viewControllers = [tab1, tab2, tab3]
        tabBarVC.selectedIndex = 0
        tabBarVC.selectedViewController = tab1
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { // seconds.
//           tabBarVC.selectedViewController = tab2
//        }
        
        tabBarVC.modalPresentationStyle = .overFullScreen
        present(tabBarVC, animated: true, completion: nil)
    }
}


class TabBarController: UITabBarController {
    
    // change transition animation if tab is swiped
    var swipeActionDetected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        
        delegate = self
        
        tabBar.isTranslucent = true
        tabBar.tintColor = .blue
        tabBar.unselectedItemTintColor = .gray
        tabBar.barTintColor = UIColor.white.withAlphaComponent(0.92)
        tabBar.itemSpacing = 10.0
        tabBar.itemWidth = 76.0
        tabBar.itemPositioning = .centered
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
       
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if sender.direction == .left {
            swipeActionDetected = true
            if self.selectedIndex < 2 {
                self.delegate?.tabBarController?(self, shouldSelect: self.viewControllers![self.selectedIndex+1])
                self.selectedIndex += 1
            }
        }
        if sender.direction == .right {
            swipeActionDetected = true
            if self.selectedIndex > 0 {
                self.delegate?.tabBarController?(self, shouldSelect: self.viewControllers![self.selectedIndex-1])
                self.selectedIndex -= 1
            }
        }
    }
    
}

extension TabBarController: UITabBarControllerDelegate {

    // for animation
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let fromView: UIView = tabBarController.selectedViewController!.view
        let toView  : UIView = viewController.view
        if fromView == toView {
            return false
        }
        
        if swipeActionDetected == true {
            self.swipeActionDetected = false
            if fromView.tag < toView.tag {
                UIView.transition(from: fromView, to: toView, duration: 0.5, options: UIView.AnimationOptions.transitionFlipFromRight) { (finished:Bool) in
                    
                }
            } else {
                UIView.transition(from: fromView, to: toView, duration: 0.5, options: UIView.AnimationOptions.transitionFlipFromLeft) { (finished:Bool) in
                
                }
            }
        } else {
            UIView.transition(from: fromView, to: toView, duration: 0.5, options: UIView.AnimationOptions.transitionCrossDissolve) { (finished:Bool) in

            }
        }
        
        
        return true
    }
    
}

class Page1VC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        view.tag = 1
        
        let label = UITextView()
        view.addSubview(label)
        label.text = "Page 1"
        label.frame = CGRect(x: 100, y: 100, width: 100, height: 30)
    }
}

class Page2VC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        view.tag = 2
        
        let label = UITextView()
        view.addSubview(label)
        label.text = "Page 2"
        label.frame = CGRect(x: 100, y: 100, width: 100, height: 30)
    }
}

class Page3VC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        view.tag = 3
        
        let label = UITextView()
        view.addSubview(label)
        label.text = "Page 3"
        label.frame = CGRect(x: 100, y: 100, width: 100, height: 30)
    }
}

```