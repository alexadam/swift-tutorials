# View with custom swipe menu

## Implement left / right swipe

```
import UIKit

class CustomSwipeMenu: UIViewController {
    
    let swipeMeView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        
        view.addSubview(swipeMeView)
        swipeMeView.backgroundColor = .blue
        swipeMeView.frame = CGRect(x: 100, y: 100, width: 250, height: 60)
        swipeMeView.translatesAutoresizingMaskIntoConstraints = false
        swipeMeView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        swipeMeView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 100).isActive = true
        swipeMeView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -100).isActive = true
        swipeMeView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
            
        leftSwipe.direction = .left
        rightSwipe.direction = .right

        swipeMeView.addGestureRecognizer(leftSwipe)
        swipeMeView.addGestureRecognizer(rightSwipe)
        
        
        let close = UIButton()
        view.addSubview(close)
        close.setTitle("close", for: .normal)
        close.setTitleColor(.black, for: .normal)
        close.backgroundColor = .white
        close.frame = CGRect(x: 100, y: 400, width: 250, height: 30)
        close.addTarget(self, action: #selector(closeAction), for: .touchDown)
    }
    
   @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {

        if (sender.direction == .left) {
                print("Swipe Left")
//            let labelPosition = CGPoint(x: swipeMeView.frame.origin.x - 50.0, y: swipeMeView.frame.origin.y)
//            swipeMeView.frame = CGRect(x: labelPosition.x, y: labelPosition.y, width: swipeMeView.frame.size.width, height: swipeMeView.frame.size.height)
            
            let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut, animations: {
                self.swipeMeView.transform = CGAffineTransform(translationX: -50, y: 0)
            })
            animator.startAnimation()
        }
            
        if (sender.direction == .right) {
            print("Swipe Right")
//            let labelPosition = CGPoint(x: self.swipeMeView.frame.origin.x + 50.0, y: self.swipeMeView.frame.origin.y)
//            swipeMeView.frame = CGRect(x: labelPosition.x, y: labelPosition.y, width: self.swipeMeView.frame.size.width, height: self.swipeMeView.frame.size.height)
            
            let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut, animations: {
                self.swipeMeView.transform = CGAffineTransform(translationX: 50, y: 0)
            })
            animator.startAnimation()
        }
    }
    
    @objc func closeAction() {
        dismiss(animated: true, completion: nil)
    }
}

```

## With dummy hidden menu

```
import UIKit

class CustomSwipeMenu: UIViewController {
    
    let swipeMeView = UIView()
    let hiddenMenu = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        
        view.addSubview(swipeMeView)
        swipeMeView.backgroundColor = .blue
        swipeMeView.frame = CGRect(x: 100, y: 100, width: 250, height: 60)
        swipeMeView.translatesAutoresizingMaskIntoConstraints = false
        swipeMeView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        swipeMeView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 100).isActive = true
        swipeMeView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -100).isActive = true
        swipeMeView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        view.addSubview(hiddenMenu)
        hiddenMenu.backgroundColor = .red
        hiddenMenu.translatesAutoresizingMaskIntoConstraints = false
        hiddenMenu.topAnchor.constraint(equalTo: swipeMeView.topAnchor, constant: 0).isActive = true
        hiddenMenu.rightAnchor.constraint(equalTo: swipeMeView.rightAnchor, constant: 0).isActive = true
        hiddenMenu.heightAnchor.constraint(equalToConstant: 60).isActive = true
        hiddenMenu.widthAnchor.constraint(equalToConstant: 120).isActive = true
        hiddenMenu.alpha = 0
        hiddenMenu.isHidden = true
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
            
        leftSwipe.direction = .left
        rightSwipe.direction = .right

        swipeMeView.addGestureRecognizer(leftSwipe)
        swipeMeView.addGestureRecognizer(rightSwipe)
        
        
        let close = UIButton()
        view.addSubview(close)
        close.setTitle("close", for: .normal)
        close.setTitleColor(.black, for: .normal)
        close.backgroundColor = .white
        close.frame = CGRect(x: 100, y: 400, width: 250, height: 30)
        close.addTarget(self, action: #selector(closeAction), for: .touchDown)
    }
    
   @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {

        if (sender.direction == .left) {
            hiddenMenu.isHidden = false
            
            let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut, animations: {
                self.swipeMeView.transform = CGAffineTransform(translationX: -120, y: 0)
                self.hiddenMenu.alpha = 1
            })
            animator.startAnimation()
        }
            
        if (sender.direction == .right) {
            let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut, animations: {
                self.hiddenMenu.alpha = 0
                self.swipeMeView.transform = CGAffineTransform(translationX: 50, y: 0)
            })
            animator.startAnimation()
            animator.addCompletion({animationPosition in
                print("done", animationPosition.rawValue)
                self.hiddenMenu.isHidden = true
            })
        }
    }
    
    @objc func closeAction() {
        dismiss(animated: true, completion: nil)
    }
}
```