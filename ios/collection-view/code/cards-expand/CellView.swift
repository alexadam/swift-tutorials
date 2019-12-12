

import UIKit

class CellView: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    static let identifier = "CellView"
    let cellLabel = UITextView()
    let descriptionLabel = UITextView()
    let closeButton = UIButton()
    var labelData: String? {
        didSet {
            cellLabel.text = self.labelData
        }
    }
    private var containerCollectionView: UICollectionView?
    private var index: Int?
    private var cellSize: CGSize?
    
    
    
    /// expand / collapse
    private var state: State = .collapsed
    private var initialFrame: CGRect?
    
    private lazy var panRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(cellViewPanned))
        recognizer.delegate = self
        
        return recognizer
    }()
    
    private lazy var animator: UIViewPropertyAnimator = {
        let cubicTiming = UICubicTimingParameters(controlPoint1: CGPoint(x: 0.17, y: 0.67), controlPoint2: CGPoint(x: 0.76, y: 1.0))
        
        let springTiming = UISpringTimingParameters(mass: 1.0, stiffness: 2.0, damping: 0.2, initialVelocity: .zero)
        
        return UIViewPropertyAnimator(duration: 0.3, timingParameters: cubicTiming)
    }()
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func createLayout() {
//        self.addGestureRecognizer(panRecognizer)
        
        let dim = 1 as CGFloat
        
        addSubview(cellLabel)
        cellLabel.translatesAutoresizingMaskIntoConstraints = false
        cellLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: dim).isActive = true
        cellLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -dim).isActive = true
        cellLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: dim).isActive = true
        cellLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -dim).isActive = true
        cellLabel.isEditable = false
        cellLabel.isSelectable = false
        
        addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: dim).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -dim).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: dim).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -dim).isActive = true
        descriptionLabel.isEditable = false
        descriptionLabel.isSelectable = false
        descriptionLabel.text = " ajdkajdkaj kasjd adajdsk jadj kajd ad kajdkajsdkajs akdj aksjdadaiuiwyiypoi ;lk ; i oip oi"
        descriptionLabel.alpha = 0
        
        addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: dim).isActive = true
        closeButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -dim).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        closeButton.setTitle("X", for: .normal)
        closeButton.setTitleColor(.black, for: .normal)
        closeButton.alpha = 0
        closeButton.addTarget(self, action: #selector(closePopUp), for: .touchDown)
        
    }
    
    func setData(containerCollectionView: UICollectionView, cellSize: CGSize, index: Int) {
        self.containerCollectionView = containerCollectionView
        self.cellSize = cellSize
        self.index = index
    }
    
    
    @objc func closePopUp() {
        toggle()
    }
    
    @objc func cellViewPanned(recognizer: UIPanGestureRecognizer) {
        let popupOffset: CGFloat = (UIScreen.main.bounds.height - cellSize!.height)/2.0
        var animationProgress: CGFloat = 0
        
        switch recognizer.state {
        case .began:
            
            toggle()
            animator.pauseAnimation()
            animationProgress = animator.fractionComplete
            
        case .changed:
            let translation = recognizer.translation(in: containerCollectionView)
            var fraction = -translation.y / popupOffset
            if state == .expanded { fraction *= -1 }
            if animator.isReversed { fraction *= -1 }
            animator.fractionComplete = fraction + animationProgress
            
        case .ended:
            let velocity = recognizer.velocity(in: self)
            let shouldComplete = velocity.y > 0
            print("Velocity Y: \(velocity.y)")
            if velocity.y == 0 {
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                break
            }
            switch state {
            case .expanded:
                if !shouldComplete && !animator.isReversed { animator.isReversed = !animator.isReversed }
                if shouldComplete && animator.isReversed { animator.isReversed = !animator.isReversed }
            case .collapsed:
                if shouldComplete && !animator.isReversed { animator.isReversed = !animator.isReversed }
                if !shouldComplete && animator.isReversed { animator.isReversed = !animator.isReversed }
            }
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            
        default:
            ()
        }
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
//        return abs((panRecognizer.velocity(in: panRecognizer.view)).y) > abs((panRecognizer.velocity(in: panRecognizer.view)).x)
    }
    
    
    
    
    func toggle() {
        switch state {
        case .expanded:
            collapse()
        case .collapsed:
            expand()
        }
    }
    
    private func expand() {
        print("expand")
        guard let collectionView = self.containerCollectionView, let index = self.index else { return }
        
        animator.addAnimations {
            self.initialFrame = self.frame
            
            self.descriptionLabel.alpha = 1
            self.closeButton.alpha = 1
            
            self.layer.cornerRadius = 0
            self.frame = CGRect(x: collectionView.contentOffset.x, y:0 , width: collectionView.frame.width, height: collectionView.frame.height)
            
            print(self.frame)
            
            if let leftCell = collectionView.cellForItem(at: IndexPath(row: index - 1, section: 0)) {
                leftCell.center.x -= 50
            }
            
            if let rightCell = collectionView.cellForItem(at: IndexPath(row: index + 1, section: 0)) {
                rightCell.center.x += 50
            }
            
            self.layoutIfNeeded()
        }
        
        animator.addCompletion { position in
            switch position {
            case .end:
                self.state = self.state.change
                collectionView.isScrollEnabled = false
                collectionView.allowsSelection = false
            default:
                ()
            }
        }
        
        animator.startAnimation()
    }
    
    private func collapse() {
        guard let collectionView = self.containerCollectionView, let index = self.index else { return }
        
        animator.addAnimations {
            self.descriptionLabel.alpha = 0
            self.closeButton.alpha = 0
            
//            self.layer.cornerRadius = self.cornerRadius
            self.frame = self.initialFrame!
            
            if let leftCell = collectionView.cellForItem(at: IndexPath(row: index - 1, section: 0)) {
                leftCell.center.x += 50
            }
            
            if let rightCell = collectionView.cellForItem(at: IndexPath(row: index + 1, section: 0)) {
                rightCell.center.x -= 50
            }
            
            self.layoutIfNeeded()
        }
        
        animator.addCompletion { position in
            switch position {
            case .end:
                self.state = self.state.change
                collectionView.isScrollEnabled = true
                collectionView.allowsSelection = true
            default:
                ()
            }
        }
        
        animator.startAnimation()
    }
}



private enum State {
    case expanded
    case collapsed
    
    var change: State {
        switch self {
        case .expanded: return .collapsed
        case .collapsed: return .expanded
        }
    }
}
