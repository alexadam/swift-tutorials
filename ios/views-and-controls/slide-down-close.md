# Slide down menu to close

```

import UIKit

// src: https://www.thorntech.com/2016/02/ios-tutorial-close-modal-dragging/

class SlideDownCloseMenu: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let button = UIButton()
        view.addSubview(button)
        button.setTitle("display popup", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .red
        button.frame = CGRect(x: 100, y: 100, width: 150, height: 30)
        button.addTarget(self, action: #selector(displayPopup), for: .touchDown)
    }

    @objc func displayPopup() {
        let popUpVC = PopUpView()
        popUpVC.transitioningDelegate = self
        present(popUpVC, animated: true, completion: nil)
    }
}

extension SlideDownCloseMenu: UIViewControllerTransitioningDelegate {
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CloseModalViewAnimator()
    }
}


class PopUpView: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange
        
        let label = UILabel()
        view.addSubview(label)
        label.text = "Hello"
        label.frame = CGRect(x: 100, y: 100, width: 100, height: 30)
    }
}

class CloseModalViewAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let containerView = transitionContext.containerView
//        guard
//            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
//            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
//            let containerView = transitionContext.containerView
//        else {
//            return
//        }
        
        containerView.insertSubview(toVC!.view, belowSubview: fromVC!.view)
        
        let screenBounds = UIScreen.main.bounds
        let bottomLeftCorner = CGPoint(x: 0, y: screenBounds.height)
        let finalFrame = CGRect(origin: bottomLeftCorner, size: screenBounds.size)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                fromVC!.view.frame = finalFrame
            },
            completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
    }
    
}

```