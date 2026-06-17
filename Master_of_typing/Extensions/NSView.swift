
import Foundation
import AppKit

extension NSView {
    func setClipToBounds(_ isClip: Bool) {
        self.wantsLayer = true
        self.layer?.masksToBounds = isClip
    }
    var bgColor: NSColor? {
        get {
            if let colorRef = self.layer?.backgroundColor {
                return NSColor(cgColor: colorRef)
            } else {
                return nil
            }
        }
        set {
            self.wantsLayer = true
            self.layer?.backgroundColor = newValue?.cgColor
        }
    }
    var backgroundColor: NSColor? {
        get {
            if let colorRef = self.layer?.backgroundColor {
                return NSColor(cgColor: colorRef)
            } else {
                return nil
            }
        }
        set {
            self.wantsLayer = true
            self.layer?.backgroundColor = newValue?.cgColor
        }
    }
    var shadowColor: NSColor? {
        get {
            if let colorRef = self.layer?.shadowColor {
                return NSColor(cgColor: colorRef)
            } else {
                return nil
            }
        }
        set {
            self.wantsLayer = true
            self.shadow = NSShadow()
            self.layer?.shadowOpacity = 0.5
            self.layer?.shadowColor = newValue?.cgColor
            //self.layer?.shadowOffset = NSMakeSize(1, -1)
            //            self.layer?.shadowRadius = 1
        }
    }
    
    var shadowX: CGFloat{
        get{
            return 0
        }
        set{
            self.layer?.shadowOffset = CGSize(width: newValue, height: self.layer?.shadowOffset.height ?? 0)
        }
    }
    var shadowY: CGFloat{
        get{
            return 0
        }
        set{
            self.layer?.shadowOffset = CGSize(width: self.layer?.shadowOffset.width ?? 0, height: newValue)
        }
    }
    
    
    var blur: CGFloat{
        get{
            return self.layer?.shadowRadius ?? 0.0
        }
        set{
            self.layer?.shadowRadius = newValue
            print(newValue)
        }
    }
    
    
    var cRadius: CGFloat {
        get {
            return self.layer?.cornerRadius ?? 0.0
        }
        set {
            self.wantsLayer = true
            self.layer?.cornerRadius = newValue
        }
    }
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer?.cornerRadius ?? 0.0
        }
        set {
            self.wantsLayer = true
            self.layer?.cornerRadius = newValue
        }
    }
    @IBInspectable var borderW: CGFloat {
        get {
            return self.layer?.borderWidth ?? 0.0
        }
        set {
            self.wantsLayer = true
            self.layer?.borderWidth = newValue
        }
    }
    @IBInspectable var borderColour: NSColor? {
        get {
            if let colorRef = self.layer?.borderColor {
                return NSColor(cgColor: colorRef)
            } else {
                return nil
            }
        }
        set {
            self.wantsLayer = true
            self.layer?.borderColor = newValue?.cgColor
        }
    }
    @IBInspectable var isCircle: Bool {
        get {
            return self.layer?.cornerRadius == (self.frame.height / 2)
        }
        set {
            self.wantsLayer = true
            if newValue {
                let minDimension = min(self.frame.width, self.frame.height)
                self.layer?.cornerRadius = minDimension / 2
                self.layer?.masksToBounds = true
            } else {
                self.layer?.cornerRadius = 0
            }
        }
    }
    func applyGradient(colors: [NSColor], startPoint: CGPoint, endPoint: CGPoint) {
        self.wantsLayer = true
        if let sublayers = self.layer?.sublayers {
            for sublayer in sublayers {
                if sublayer is CAGradientLayer {
                    sublayer.removeFromSuperlayer()
                }
            }
        }
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = self.bounds
        self.layer?.addSublayer(gradientLayer)
    }
    var center: CGPoint {
        get { return CGPoint(x: NSMidX(frame), y: NSMidY(frame)) }
        set {
            setFrameOrigin(CGPoint(x: newValue.x - frame.width / 2.0,y: newValue.y - frame.height / 2.0))
        }
    }
    func setAnchorPoint(anchorPoint: CGPoint) {
        if let layer = self.layer {
            var newPoint = CGPoint(x: self.bounds.size.width * anchorPoint.x,y: self.bounds.size.height * anchorPoint.y)
            var oldPoint = CGPoint(x: self.bounds.size.width * layer.anchorPoint.x,y: self.bounds.size.height * layer.anchorPoint.y)
            newPoint = newPoint.applying(layer.affineTransform())
            oldPoint = oldPoint.applying(layer.affineTransform())
            var position = layer.position
            position.x -= oldPoint.x
            position.x += newPoint.x
            position.y -= oldPoint.y
            position.y += newPoint.y
            layer.position = position
            layer.anchorPoint = anchorPoint
        }
    }
    func applyLinearGradientBackground(
        colors: [NSColor], startPoint: CGPoint, endPoint: CGPoint
    ) {
        self.layer?.sublayers?.filter { $0.name == "GradientBackgroundLayer" }
            .forEach { $0.removeFromSuperlayer() }
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "GradientBackgroundLayer"
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.cornerRadius = self.layer?.cornerRadius ?? 0
        gradientLayer.masksToBounds = true
        if self.layer == nil {
            self.wantsLayer = true
        }
        self.layer?.addSublayer(gradientLayer)
        self.postsFrameChangedNotifications = true
        NotificationCenter.default.addObserver(
            forName: NSView.frameDidChangeNotification, object: self,
            queue: .main
        ) { [weak self] _ in
            gradientLayer.frame = self?.bounds ?? .zero
        }
    }
    func clearGradientBackground() {
        self.layer?.sublayers?.filter { $0.name == "GradientBackgroundLayer" }
            .forEach { $0.removeFromSuperlayer() }
    }
    func addShadow(color: NSColor = .black, offset: CGSize = .zero, radius: CGFloat = 5,opacity: Float = 0.1) {
        self.layer?.masksToBounds = false
        self.layer?.shadowColor = color.cgColor
        self.layer?.shadowOffset = offset
        self.layer?.shadowRadius = radius
        self.layer?.shadowOpacity = opacity
    }
    func addTapGesture(target: Any?, action: Selector?) {
        let gesture = NSClickGestureRecognizer(target: target, action: action)
        addGestureRecognizer(gesture)
    }
    func roundSpecificCorners(cornerRadius: CGFloat = 20, maskedCorners: CACornerMask) {
        wantsLayer = true
        layer?.cornerRadius = cornerRadius
        layer?.maskedCorners = maskedCorners
        layer?.borderColor = NSColor.clear.cgColor
        layer?.borderWidth = 0
        layer?.masksToBounds = true
    }
}
// MARK: - View Loading
//public extension NSView {
//    class func view<T: NSView>(with owner: AnyObject?,
//                               bundle: Bundle = Bundle.main) throws -> T {
//        let className = String(describing: self)
//        return try self.view(from: className, owner: owner, bundle: bundle)
//    }
//
//    class func view<T: NSView>(from nibName: String,
//                               owner: AnyObject?,
//                               bundle: Bundle = Bundle.main) throws -> T {
//        var topLevelObjects: NSArray? = []
//        guard bundle.loadNibNamed(NSNib.Name( nibName), owner: owner, topLevelObjects: &topLevelObjects),
//            let objects = topLevelObjects else {
//                throw NibLoadingError.nibNotFound
//        }
//
//        let views = objects.filter { object in object is NSView }
//
//        if views.count > 1 {
//            throw NibLoadingError.multipleTopLevelObjectsFound
//        }
//
//        guard let view = views.first as? T else {
//            throw NibLoadingError.topLevelObjectNotFound
//        }
//        return view
//    }
//}

extension NSView {
    func centerInView(_ superview: NSView) {
        self.frame.origin = CGPoint(
            x: (superview.bounds.width - self.bounds.width) / 2,
            y: (superview.bounds.height - self.bounds.height) / 2
        )
    }
    
    func setSize(width: CGFloat, height: CGFloat) {
        self.frame.size = CGSize(width: width, height: height)
    }
}

class DisableInteraction: NSView {

    var userInteractionEnabled: Bool = true
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        if userInteractionEnabled {
            return super.hitTest(point)
        }
        return nil
    }
}
