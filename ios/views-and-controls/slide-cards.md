# Slide Cards - expand / collapse like in AppStore (WIP)

src: https://medium.com/@aunnnn/making-app-store-today-ios-11-custom-transition-part-1-presentation-9e4ef99e75d3

+ https://github.com/aunnnn/AppStoreiOS11InteractiveTransition/tree/master/AppStoreInteractiveTransition



```

import UIKit


class SlideCards: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let card = CardView()
        view.addSubview(card)
        card.cardInteractionDelegate = self
        card.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
    }

}


protocol CardInteractionProtocol {
    func expandCard(cardId: Int, card: CardView)
}

extension SlideCards: CardInteractionProtocol {
    func expandCard(cardId: Int, card: CardView) {
        let popUpVC = ExpandedCardViewController()
        popUpVC.transitioningDelegate = card
        popUpVC.modalPresentationStyle = .custom
        present(popUpVC, animated: true, completion: nil)
    }
}

class CardView: UIView {
    
    var cardInteractionDelegate: CardInteractionProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func createLayout() {
        backgroundColor = .orange
        
        // !! single Tap
        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
        tapGesture.minimumPressDuration = 0
        
        addGestureRecognizer(tapGesture)
        
        let label = UILabel()
        addSubview(label)
        label.text = "Hello"
        label.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
    }
    
    @objc func handleTap(gesture: UITapGestureRecognizer) {
        
        if gesture.state == .began {
            animate(shrink: true)
            return
        }
        
        if gesture.state == .ended  { //|| gesture.state == .failed {
            animate(shrink: false)
            return
        }
    }
    
    func animate(shrink: Bool) {
        if shrink {
            let animator = UIViewPropertyAnimator(duration: 0.4, curve: .easeInOut, animations: {
               self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
               self.backgroundColor = .darkGray
            })
            animator.startAnimation()
        } else {
            self.cardInteractionDelegate?.expandCard(cardId: 0, card: self)
            let animator = UIViewPropertyAnimator(duration: 0.4, curve: .easeInOut, animations: {
                self.transform = .identity
                self.backgroundColor = .orange
            })
            animator.startAnimation()
//            animator.addCompletion { (_) in
//
//            }
        }
    }

}

extension CardView: UIViewControllerTransitioningDelegate {
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideCardsViewAnimator()
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ExpandCardAnimator(cardView: self)
    }
}

class ExpandedCardViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
        
        let label = UILabel()
        view.addSubview(label)
        label.text = "Hello"
        label.frame = CGRect(x: 100, y: 100, width: 200, height: 30)
        
        let button = UIButton()
        view.addSubview(button)
        button.setTitle("CLose", for: .normal)
        button.frame = CGRect(x: 100, y: 200, width: 200, height: 200)
        button.addTarget(self, action: #selector(close), for: .touchDown)
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
}

class SlideCardsViewAnimator: NSObject, UIViewControllerAnimatedTransitioning {
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

class ExpandCardAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var cardView: CardView!
    
    init(cardView: CardView) {
        self.cardView = cardView
        super.init()
    }
    
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
        
        toVC?.view.frame = cardView.frame
        containerView.backgroundColor = .clear
        containerView.insertSubview(toVC!.view, belowSubview: fromVC!.view)
        
        let screenBounds = UIScreen.main.bounds
        let bottomLeftCorner = CGPoint(x: 0, y: screenBounds.height)
        let topLeftCorner = CGPoint(x: 0, y: 0)
        let finalFrame = CGRect(origin: topLeftCorner, size: screenBounds.size)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
//                fromVC!.view.frame = finalFrame
                toVC?.view.frame = finalFrame // CGRect(x: 50, y: 50, width: 300, height: 500)
//                fromVC?.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            },
            completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                containerView.insertSubview(toVC!.view, belowSubview: fromVC!.view)
            })
    }
    
}

```