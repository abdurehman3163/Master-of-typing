import Cocoa

class CircularProgressView: NSView {
    
    var progress: Double = 0.0 {
        didSet {
            progress = max(0.0, min(1.0, progress))
            // Use layer for fast updates instead of full redraw
            updateProgressLayer()
        }
    }
    
    // Configurable appearance
    var trackColor: NSColor = NSColor.whiteColor2
    var progressColor: NSColor = NSColor.appMain
    var textColor: NSColor = NSColor.black
    var lineWidth: CGFloat = 10.0
    var fontSize: CGFloat = 18.0
    
    // Private layers for performance
    private let trackLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    private let textLayer = CATextLayer()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    private func setupLayers() {
        wantsLayer = true
        layer?.backgroundColor = nil // Transparent
        
        // Track layer (background ring)
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.fillColor = nil
        trackLayer.lineCap = .round
        layer?.addSublayer(trackLayer)
        
        // Progress layer
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.fillColor = nil
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0 // Start empty
        layer?.addSublayer(progressLayer)
        
        // Text layer
        textLayer.alignmentMode = .center
        textLayer.contentsScale = NSScreen.main?.backingScaleFactor ?? 1.0
        textLayer.font = CTFontCreateWithName("Helvetica-Bold" as CFString, fontSize, nil)
        textLayer.fontSize = fontSize
        textLayer.foregroundColor = textColor.cgColor
        layer?.addSublayer(textLayer)
    }
    
    override func layout() {
        super.layout()
        updateAllLayers()
    }
    
    private func updateAllLayers() {
        guard let layer = layer, bounds.width > 0, bounds.height > 0 else { return }
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = (min(bounds.width, bounds.height) / 2) - (lineWidth / 2)
        
        let circularPath = CGPath(ellipseIn: CGRect(x: center.x - radius, y: center.y - radius,
                                                    width: radius * 2, height: radius * 2), transform: nil)
        
        // Update track
        trackLayer.path = circularPath
        trackLayer.lineWidth = lineWidth
        
        // Update progress
        progressLayer.path = circularPath
        progressLayer.lineWidth = lineWidth
        
        // Update text position
        let textRect = CGRect(x: 0, y: bounds.midY - fontSize / 2, width: bounds.width, height: fontSize + 4)
        textLayer.frame = textRect
        textLayer.string = String(format: "%.0f%%", progress * 100)
    }
    
    private func updateProgressLayer() {
        // Only update strokeEnd — super fast!
        CATransaction.begin()
        CATransaction.setDisableActions(true) // Prevent implicit animation flicker
        progressLayer.strokeEnd = CGFloat(progress)
        CATransaction.commit()
        
        // Update text smoothly
        textLayer.string = String(format: "%.0f%%", progress * 100)
    }
    
    // Optional: Smooth animated progress
    func setProgress(_ newProgress: Double, animated: Bool = true, duration: CFTimeInterval = 0.3) {
        let clamped = max(0.0, min(1.0, newProgress))
        
        if animated {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = progressLayer.strokeEnd
            animation.toValue = clamped
            animation.duration = duration
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            progressLayer.add(animation, forKey: "progressAnimation")
        }
        
        progress = clamped // This triggers updateProgressLayer()
    }
}
