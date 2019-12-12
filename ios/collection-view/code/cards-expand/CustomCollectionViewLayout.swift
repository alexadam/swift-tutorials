

import UIKit

/**
 
 src: https://www.appcoda.com/interactive-animation-uiviewpropertyanimator/
 & https://github.com/appcoda/Interactive-Animation/tree/master/CityGuide
 
 */

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
