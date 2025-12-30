import Foundation
import Cocoa

extension NSCollectionView {
    func selectItem(index: Int, section: Int, scrollPosition: NSCollectionView.ScrollPosition = .left) {
        selectItems(at: [IndexPath(item: index, section: section)], scrollPosition: scrollPosition)
    }

    func scrollToTop(animated: Bool) {
        guard let scrollView = enclosingScrollView else { return }
        let targetOffset = NSPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.height)
        if animated {
            NSAnimationContext.runAnimationGroup({ context in
                context.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
                context.duration = 0.5
                scrollView.contentView.animator().setBoundsOrigin(targetOffset)
            }, completionHandler: nil)
        } else {
            scrollView.contentView.setBoundsOrigin(targetOffset)
        }
    }
    func hideVerticalScroller() {
        enclosingScrollView?.scrollerInsets = NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 2000)
    }
    
    func hideHorizontalScroller() {
        enclosingScrollView?.scrollerInsets = NSEdgeInsets(top: 0, left: 0, bottom: 2000, right: 0)
    }
    
    func getNib(name: String) -> NSNib? {
        NSNib(nibNamed: name, bundle: nil)
    }
    func scrollToItem(at section: Int, scrollPosition: NSCollectionView.ScrollPosition = .centeredHorizontally) {
        guard let layout = self.collectionViewLayout as? NSCollectionViewCompositionalLayout else {
            print("The layout must be NSCollectionViewFlowLayout")
            return
        }
        let indexPath = IndexPath(item: 0, section: section)
        if let attributes = layout.layoutAttributesForItem(at: indexPath) {
            let targetRect = NSRect(x: Int(attributes.frame.minX), y: Int(attributes.frame.minY) - 43, width: Int(attributes.frame.width), height: Int(attributes.frame.height))
            print("Target Rect is : \(attributes.frame)")
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.5
                context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                self.enclosingScrollView?.contentView.animator().setBoundsOrigin(targetRect.origin)
            }, completionHandler: nil)
        } else {
            print("Failed to retrieve layout attributes for item at \(indexPath)")
        }
    }
}
