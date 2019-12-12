# Collection View

## Setup

in **SceneDelegate.swift**, overwrite scene(...) function:

```
func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
    }
```

## Create **ViewController.swift**

```
import UIKit

class ViewController: UIViewController {

    var containerView: UICollectionView!
    var items: [String] = ["A", "B", "C", "D", "E", "F", "G", "H"]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .yellow

        createLayout()
    }

    private func createLayout() {

        containerView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        containerView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        containerView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        containerView.dataSource = self
        containerView.delegate = self
        containerView.register(CellView.self, forCellWithReuseIdentifier: CellView.identifier)

        containerView.backgroundColor = .gray
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellView.identifier, for: indexPath) as! CellView

        cell.labelData = items[indexPath.row]

        return cell
    }    
}
```

## Create **CellView.swift**

```
import UIKit

class CellView: UICollectionViewCell {

    static let identifier = "CellView"
    let cellLabel = UITextView()
    var labelData: String? {
        didSet {
            cellLabel.text = self.labelData
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        createLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func createLayout() {
        let dim = 1 as CGFloat

        addSubview(cellLabel)
        cellLabel.translatesAutoresizingMaskIntoConstraints = false
        cellLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: dim).isActive = true
        cellLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -dim).isActive = true
        cellLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: dim).isActive = true
        cellLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -dim).isActive = true
        cellLabel.isEditable = false
        cellLabel.isSelectable = false
    }

}
```

![i1][img1]


# Cards

src: https://www.appcoda.com/interactive-animation-uiviewpropertyanimator/ & https://github.com/appcoda/Interactive-Animation/tree/master/CityGuide

## Create Custom Layout

More: https://developer.apple.com/library/archive/documentation/WindowsViews/Conceptual/CollectionViewPGforIOS/CreatingCustomLayouts/CreatingCustomLayouts.html#//apple_ref/doc/uid/TP40012334-CH5-SW3

Create file **CustomCollectionViewLayout.swift**

```
import UIKit

class CustomCollectionViewLayout: UICollectionViewFlowLayout {

    var scaleOffset: CGFloat = 200
    var scaleFactor: CGFloat = 0.9
    var alphaFactor: CGFloat = 0.3
    var lineSpacing: CGFloat = 0 //5.0

    init(cardSize: CGSize = CGSize(width: 250, height: 350)) {
        super.init()
        itemSize = cardSize
        scrollDirection = .horizontal
        sectionInset = UIEdgeInsets(top: 0, left: 80, bottom: 0, right: 80)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = self.collectionView else {
            return proposedContentOffset
        }

        let proposedRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.bounds.width, height: collectionView.bounds.height)
        guard let layoutAttributes = self.layoutAttributesForElements(in: proposedRect) else {
            return proposedContentOffset
        }

        var candidateAttributes: UICollectionViewLayoutAttributes?
        let proposedContentOffsetCenterX = proposedContentOffset.x + collectionView.bounds.width / 2

        for attributes in layoutAttributes {
            if attributes.representedElementCategory != .cell {
                continue
            }

            if candidateAttributes == nil {
                candidateAttributes = attributes
                continue
            }

            if abs(attributes.center.x - proposedContentOffsetCenterX) < abs(candidateAttributes!.center.x - proposedContentOffsetCenterX) {
                candidateAttributes = attributes
            }
        }

        guard let aCandidateAttributes = candidateAttributes else {
            return proposedContentOffset
        }

        var newOffsetX = aCandidateAttributes.center.x - collectionView.bounds.size.width / 2
        let offset = newOffsetX - collectionView.contentOffset.x

        if (velocity.x < 0 && offset > 0) || (velocity.x > 0 && offset < 0) {
            let pageWidth = itemSize.width + minimumLineSpacing
            newOffsetX += velocity.x > 0 ? pageWidth : -pageWidth
        }

        return CGPoint(x: newOffsetX, y: proposedContentOffset.y)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = self.collectionView,
            let superAttributes = super.layoutAttributesForElements(in: rect) else {
                return super.layoutAttributesForElements(in: rect)
        }

        let contentOffset = collectionView.contentOffset
        let size = collectionView.bounds.size

        let visibleRect = CGRect(x: contentOffset.x, y: contentOffset.y, width: size.width, height: size.height)
        let visibleCenterX = visibleRect.midX

        guard case let newAttributesArray as [UICollectionViewLayoutAttributes] = NSArray(array: superAttributes, copyItems: true) else {
            return nil
        }

        newAttributesArray.forEach {
            let distanceFromCenter = visibleCenterX - $0.center.x
            let absDistanceFromCenter = min(abs(distanceFromCenter), self.scaleOffset)
            let scale = absDistanceFromCenter * (self.scaleFactor - 1) / self.scaleOffset + 1
            $0.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)

            let alpha = absDistanceFromCenter * (self.alphaFactor - 1) / self.scaleOffset + 1
            $0.alpha = alpha
        }

        return newAttributesArray
    }

    override func shouldInvalidateLayout(forBoundsChange _: CGRect) -> Bool {
        return true
    }

}
```

In **ViewController.swift** change:

```
containerView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

// TO

containerView = UICollectionView(frame: .zero, collectionViewLayout: CustomCollectionViewLayout(cardSize: CGSize(width: 250, height: 350)))
```

Result:

![i2][img2]


In **CustomCollectionViewLayout.swift** change:

```
let scale = absDistanceFromCenter * (self.scaleFactor - 1) / self.scaleOffset + 1

// TO

let scale = absDistanceFromCenter * (self.scaleFactor - 1) / self.scaleOffset + 1.1
```

Result:

![i3][img3]

## Expand/Collapse cell on pan

Modify **CellView.swift**:

```


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

        // NOTE does not work well
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
        self.addGestureRecognizer(panRecognizer)

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
        descriptionLabel.text = " Test Description Text"
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
        return abs((panRecognizer.velocity(in: panRecognizer.view)).y) > abs((panRecognizer.velocity(in: panRecognizer.view)).x)
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
```

in **ViewController.swift** :

```
public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellView.identifier, for: indexPath) as! CellView

        cell.labelData = items[indexPath.row]
        cell.setData(containerCollectionView: collectionView, cellSize: CGSize(width: 250, height: 350), index: indexPath.row)

        return cell
    }
```

# Create Pinterest Like Layout

src: https://www.raywenderlich.com/4829472-uicollectionview-custom-layout-tutorial-pinterest

Create file **PinterestLayout.swift**:

```
import UIKit

// src: https://www.raywenderlich.com/4829472-uicollectionview-custom-layout-tutorial-pinterest

protocol PinterestLayoutDelegate: AnyObject {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

extension ViewController: PinterestLayoutDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        return CGFloat([150, 200, 250, 300].randomElement()!)
    }
}

class PinterestLayout: UICollectionViewFlowLayout {

    override init() {
        super.init()
        scrollDirection = .vertical
        sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    weak var delegate: PinterestLayoutDelegate?
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 6
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0

    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }




    override func prepare() {
        guard
            cache.isEmpty,
            let collectionView = collectionView
            else {
                return
        }

        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)

        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let photoHeight = delegate?.collectionView(
                collectionView,
                heightForPhotoAtIndexPath: indexPath) ?? 180
            let height = cellPadding * 2 + photoHeight
            let frame = CGRect(x: xOffset[column],
                               y: yOffset[column],
                               width: columnWidth,
                               height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)

            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height

            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }

    override func layoutAttributesForElements(in rect: CGRect)
        -> [UICollectionViewLayoutAttributes]? {
            var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []

            // Loop through the cache and look for items in the rect
            for attributes in cache {
                if attributes.frame.intersects(rect) {
                    visibleLayoutAttributes.append(attributes)
                }
            }
            return visibleLayoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes? {
            return cache[indexPath.item]
    }

}
```

Modify **ViewController.swift**:

```
...
let pinterestLayout = PinterestLayout()
...

// in createLayout():

pinterestLayout.delegate = self
containerView = UICollectionView(frame: .zero, collectionViewLayout: pinterestLayout)

```

![i4][img4]



[i1]: https://github.com/alexadam/swift-tutorials/raw/master/ios/collection-view/images/s1.png "i1"
[i2]: https://github.com/alexadam/swift-tutorials/raw/master/ios/collection-view/images/s2.png "i2"
[i3]: https://github.com/alexadam/swift-tutorials/raw/master/ios/collection-view/images/s3.png "i3"
[i4]: https://github.com/alexadam/swift-tutorials/raw/master/ios/collection-view/images/s4.png "i4"
